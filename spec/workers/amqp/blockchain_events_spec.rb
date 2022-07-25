# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Layout/LineLength
# rubocop:disable RSpec/MultipleMemoizedHelpers
describe AMQP::BlockchainEvents do
  fixtures :chains, :deals, :tokens

  subject(:worker) { described_class.new }

  let!(:deal) { deals(:david_and_piter_deal) }
  let!(:chain) { chains(:goerli) }
  let!(:usdt) { tokens(:usdt) }
  let(:event_state_changed_started) { { 'kind' => 'StateChanged', 'chainId' => chain.chain_id, 'chainType' => chain.chain_type, 'blockNumber' => 4, 'txIndex' => 1, 'txHash' => '0x0000000000000000000000000000000000000000000000000000000000000007', 'contract' => usdt.address, 'seller' => '0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266', 'buyer' => '0x70997970c51812dc3a010c7d01b50e0d17dc79c8', 'amount' => '101000000000000000000', 'fee' => '1000000000000000000', 'dealId' => deal.internal_id, 'state' => 1 } }
  let(:event_state_changed_payment_complete) { { 'kind' => 'StateChanged', 'chainId' => chain.chain_id, 'chainType' => chain.chain_type, 'blockNumber' => 5, 'txIndex' => 0, 'txHash' => '0x0000000000000000000000000000000000000000000000000000000000000008', 'contract' => usdt.address, 'seller' => '0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266', 'buyer' => '0x70997970c51812dc3a010c7d01b50e0d17dc79c8', 'amount' => '101000000000000000000', 'fee' => '1000000000000000000', 'dealId' => deal.internal_id, 'state' => 2 } }
  let(:event_state_changed_dispute) { { 'kind' => 'StateChanged', 'chainId' => chain.chain_id, 'chainType' => chain.chain_type, 'blockNumber' => 3, 'txIndex' => 0, 'txHash' => '0x0000000000000000000000000000000000000000000000000000000000000004', 'contract' => usdt.address, 'seller' => '0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266', 'buyer' => '0x70997970c51812dc3a010c7d01b50e0d17dc79c8', 'amount' => '101000000000000000000', 'fee' => '1000000000000000000', 'dealId' => deal.internal_id, 'state' => 3 } }
  let(:event_state_changed_canceled_arbiter) { { 'kind' => 'StateChanged', 'chainId' => chain.chain_id, 'chainType' => chain.chain_type, 'blockNumber' => 4, 'txIndex' => 1, 'txHash' => '0x0000000000000000000000000000000000000000000000000000000000000006', 'contract' => usdt.address, 'seller' => '0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266', 'buyer' => '0x70997970c51812dc3a010c7d01b50e0d17dc79c8', 'amount' => '101000000000000000000', 'fee' => '1000000000000000000', 'dealId' => deal.internal_id, 'state' => 4 } }
  let(:event_state_changed_canceled_timeout_arbiter) { { 'kind' => 'StateChanged', 'chainId' => chain.chain_id, 'chainType' => chain.chain_type, 'blockNumber' => 2, 'txIndex' => 1, 'txHash' => '0x0000000000000000000000000000000000000000000000000000000000000004', 'contract' => usdt.address, 'seller' => '0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266', 'buyer' => '0x70997970c51812dc3a010c7d01b50e0d17dc79c8', 'amount' => '101000000000000000000', 'fee' => '1000000000000000000', 'dealId' => deal.internal_id, 'state' => 5 } }
  let(:event_state_changed_canceled_buyer) { { 'kind' => 'StateChanged', 'chainId' => chain.chain_id, 'chainType' => chain.chain_type, 'blockNumber' => 2, 'txIndex' => 1, 'txHash' => '0x0000000000000000000000000000000000000000000000000000000000000004', 'contract' => usdt.address, 'seller' => '0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266', 'buyer' => '0x70997970c51812dc3a010c7d01b50e0d17dc79c8', 'amount' => '101000000000000000000', 'fee' => '1000000000000000000', 'dealId' => deal.internal_id, 'state' => 6 } }
  # canceled seller
  let(:event_state_changed_cleared_seller) { { 'kind' => 'StateChanged', 'chainId' => chain.chain_id, 'chainType' => chain.chain_type, 'blockNumber' => 6, 'txIndex' => 2, 'txHash' => '0x000000000000000000000000000000000000000000000000000000000000000b', 'contract' => usdt.address, 'seller' => '0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266', 'buyer' => '0x70997970c51812dc3a010c7d01b50e0d17dc79c8', 'amount' => '101000000000000000000', 'fee' => '1000000000000000000', 'dealId' => deal.internal_id, 'state' => 8 } }
  let(:event_state_changed_cleared_arbiter) { { 'kind' => 'StateChanged', 'chainId' => chain.chain_id, 'chainType' => chain.chain_type, 'blockNumber' => 4, 'txIndex' => 2, 'txHash' => '0x0000000000000000000000000000000000000000000000000000000000000007', 'contract' => usdt.address, 'seller' => '0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266', 'buyer' => '0x70997970c51812dc3a010c7d01b50e0d17dc79c8', 'amount' => '101000000000000000000', 'fee' => '1000000000000000000', 'dealId' => deal.internal_id, 'state' => 9 } }

  describe '#process' do
    it 'sets deal to started state' do
      expect(deal.deal_histories.count).to eq(0)
      worker.process(event_state_changed_started, {})
      deal.reload
      expect(deal.deal_histories.count).to eq(1)
      expect(deal.started?).to be(true)
    end

    it 'sets deal to payment_complete state' do
      expect(deal.deal_histories.count).to eq(0)
      worker.process(event_state_changed_payment_complete, {})
      deal.reload
      expect(deal.deal_histories.count).to eq(1)
      expect(deal.payment_complete?).to be(true)
    end

    it 'sets deal to cleared_seller state' do
      expect(deal.deal_histories.count).to eq(0)
      worker.process(event_state_changed_cleared_seller, {})
      deal.reload
      expect(deal.deal_histories.count).to eq(1)
      expect(deal.cleared_seller?).to be(true)
    end

    it 'sets deal to dispute state' do
      expect(deal.deal_histories.count).to eq(0)
      worker.process(event_state_changed_dispute, {})
      deal.reload
      expect(deal.deal_histories.count).to eq(1)
      expect(deal.dispute?).to be(true)
    end

    it 'sets deal to canceled_arbiter state' do
      expect(deal.deal_histories.count).to eq(0)
      worker.process(event_state_changed_canceled_arbiter, {})
      deal.reload
      expect(deal.deal_histories.count).to eq(1)
      expect(deal.canceled_arbiter?).to be(true)
    end

    it 'sets deal to cleared_arbiter state' do
      expect(deal.deal_histories.count).to eq(0)
      worker.process(event_state_changed_cleared_arbiter, {})
      deal.reload
      expect(deal.deal_histories.count).to eq(1)
      expect(deal.cleared_arbiter?).to be(true)
    end

    it 'sets deal to canceled_timeout_arbiter state' do
      expect(deal.deal_histories.count).to eq(0)
      worker.process(event_state_changed_canceled_timeout_arbiter, {})
      deal.reload
      expect(deal.deal_histories.count).to eq(1)
      expect(deal.canceled_timeout_arbiter?).to be(true)
    end

    it 'sets deal to canceled_buyer state' do
      expect(deal.deal_histories.count).to eq(0)
      worker.process(event_state_changed_canceled_buyer, {})
      deal.reload
      expect(deal.deal_histories.count).to eq(1)
      expect(deal.canceled_buyer?).to be(true)
    end
  end
end
# rubocop:enable Layout/LineLength

# rubocop:enable RSpec/MultipleMemoizedHelpers
