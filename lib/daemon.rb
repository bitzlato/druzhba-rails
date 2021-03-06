# frozen_string_literal: true

require File.join(ENV.fetch('RAILS_ROOT'), 'config', 'environment')

raise 'Daemon name must be provided.' if ARGV.size.zero?

name = ARGV[0]
worker = "Daemons::#{name.camelize}".constantize.new

logger = Rails.logger

terminate = proc do
  logger.info 'Terminating worker ..'
  worker.stop
  logger.info 'Stopped.'
end

Signal.trap('INT',  &terminate)
Signal.trap('TERM', &terminate)

begin
  worker.run
rescue StandardError => e
  if is_db_connection_error?(e)
    Rails.logger.error(db: :unhealthy, message: e.message)
    raise e
  end

  report_exception(e)
end
