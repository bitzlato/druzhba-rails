# frozen_string_literal: true

module AMQP
  class BlockchainEvents < Base
    def process(payload, metadata)
      logger.info "process payload=#{payload}, metadata=#{metadata}"
      # TODO
    end
  end
end
