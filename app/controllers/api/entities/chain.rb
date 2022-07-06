# frozen_string_literal: true

module Api
  module Entities
    class Chain < Grape::Entity
      expose :id, documentation: { type: Integer, desc: 'Unique blockchain identifier in database.' }
      expose :name, documentation: { type: String, desc: 'A name to identify blockchain.' }
      expose :explorer_address, documentation: { type: String, desc: 'Blockchain explorer address url.' }
      expose :explorer_token, documentation: { type: String, desc: 'Blockchain explorer token url.' }
      expose :explorer_tx, documentation: { type: String, desc: 'Blockchain explorer tx url' }
      expose :metamask_rpc, documentation: { type: String, desc: 'JSON-RPC endpoint for metamask' }
    end
  end
end
