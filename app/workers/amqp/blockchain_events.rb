# frozen_string_literal: true

module AMQP
  class BlockchainEvents < Base
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize

    attr_reader :payload

    def process(payload, _metadata)
      @payload = payload

      case payload['kind']
      when 'LockedTransfer'
        process_locked_transfer
      when 'StateChanged'
        process_state_changed
      when 'ArbiterChanged'
        process_arbiter_changed
      when 'SignerChanged'
        process_signer_changed
      else
        raise "unknown payload kind: #{payload['kind']}"
      end
    end

    def process_locked_transfer; end

    def process_arbiter_changed; end

    def process_signer_changed; end

    def process_state_changed
      ActiveRecord::Base.transaction do
        deal = Deal.find_by!(internal_id: payload['dealId'])

        attributes = {
          block_number: payload['blockNumber'],
          tx_index: payload['txIndex'],
          state: payload['state'],
          payload: payload
        }
        history = deal.deal_histories.create_with(attributes).find_or_create_by(tx_hash: payload['txHash'])

        unless history.block_number == payload['blockNumber']
          report_exception 'Invalid tx block number for deal history', true, {
            id: history.id, new_block: payload['blockNumber']
          }
        end

        deal.update_state_from_history!
      end
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize
  end
end
