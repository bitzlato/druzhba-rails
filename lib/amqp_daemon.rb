# frozen_string_literal: true

require File.join(ENV.fetch('RAILS_ROOT'), 'config', 'environment')

# rubocop:disable Metrics/BlockLength
# rubocop:disable Rails/Output
# rubocop:disable Rails/Exit

raise 'bindings must be provided.' if ARGV.size.zero?

logger = Rails.logger

conn = Bunny.new AMQP::Config.connect
conn.start

ch = conn.create_channel

# Setup prefetch option
#
channel_id = ARGV.first.split(':').first
prefetch = AMQP::Config.channel(channel_id)[:prefetch] || 0
ch.prefetch(prefetch) if prefetch.positive?
logger.info do
  "Connected to AMQP broker (channel_id: #{channel_id || :nil}, prefetch: #{prefetch.positive? ? prefetch : 'default'})"
end

# Setup signal trapping
#
terminate = proc do
  # logger is forbidden in signal handling, just use puts here
  puts 'Terminating threads ..'
  ch.work_pool.kill
  puts 'Stopped.'
end
at_exit { conn.close }
Signal.trap('INT',  &terminate)
Signal.trap('TERM', &terminate)

workers = ARGV.map do |binding_id|
  binding = AMQP::Config.binding binding_id
  logger.info "Bind as '#{binding_id}' with args #{binding}"

  worker = ::AMQP.const_get(binding_id.to_s.camelize).new
  queue  = ch.queue(binding.fetch(:queue), durable: binding[:durable])

  if defined? Bugsnag
    Bugsnag.configure do |config|
      config.add_on_error(proc do |event|
        event.add_metadata(:amqp, :worker, worker.class)
      end)
    end
  end

  exchange = ch.send(* AMQP::Config.exchange(binding.fetch(:exchange)))

  case binding[:type].to_s
  when 'direct'
    routing_key = binding.fetch(:routing_key)
    logger.info("Type 'direct' routing_key = #{routing_key}")
    queue.bind exchange, routing_key: routing_key
  when 'topic'
    binding[:topics].each do |topic|
      logger.info("Type 'topic' routing_key (topic) = #{topic}")
      queue.bind exchange, routing_key: topic
    end
  when 'fanout'
    queue.bind exchange
  else
    raise 'unknown type'
  end

  queue.purge if binding[:clean_start]

  # Enable manual acknowledge mode by setting manual_ack: true.
  queue.subscribe manual_ack: true do |delivery_info, metadata, payload|
    logger.info { "Received: #{payload}" }
    callback = proc do |event|
      params = { message_payload: payload, message_metadata: metadata, message_delivery_info: delivery_info }
      event.add_metadata(:amqp, params)
    end
    Bugsnag.add_on_error(callback)

    # Invoke Worker#process with floating number of arguments.
    args          = [JSON.parse(payload), metadata, delivery_info]
    arity         = worker.method(:process).arity
    resized_args  = arity.negative? ? args : args[0...arity]
    worker.process(*resized_args)

    # Send confirmation to RabbitMQ that message has been successfully processed.
    # See http://rubybunny.info/articles/queues.html
    ch.ack(delivery_info.delivery_tag)
  rescue StandardError => e
    # Ask RabbitMQ to deliver message once again later.
    # See http://rubybunny.info/articles/queues.html
    ch.nack(delivery_info.delivery_tag, false, true)

    if is_db_connection_error?(e)
      logger.error(db: :unhealthy, message: e.message)
      exit(1)
    end

    params = { message_payload: payload, message_metadata: metadata, message_delivery_info: delivery_info }

    report_exception(e, true, params)
  ensure
    Bugsnag.remove_on_error(callback)
  end

  worker
end

%w[USR1 USR2].each do |signal|
  Signal.trap(signal) do
    puts "#{signal} received."
    handler = "on_#{signal.downcase}"
    workers.each { |w| w.send handler if w.respond_to?(handler) }
  end
end

ch.work_pool.join

# rubocop:enable Rails/Exit
# rubocop:enable Rails/Output
# rubocop:enable Metrics/BlockLength
