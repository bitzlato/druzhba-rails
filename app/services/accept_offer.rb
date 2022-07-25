# frozen_string_literal: true

# Cоздает сделку из офера в статусе черновик

class AcceptOffer
  DEADLINE_IN_MUNUTES = 30

  attr_reader :offer, :deal_params, :deal

  def initialize(offer, deal_params)
    @offer = offer
    @deal_params = deal_params.slice(:locked, :buyer)
  end

  def call
    Deal.transaction do
      build_deal
      set_internal_id
      set_deadline
      set_fee
      set_signature
      @deal.save
    end
  end

  private

  def build_deal
    @deal = Deal.new(
      offer: offer,
      seller_id: offer.user_id,
      token: offer.token,
      **deal_params
    )
  end

  def set_internal_id
    existed_internal_ids = Deal.not_finished.where(token: offer.token).order(:id).pluck(:internal_id)
    new_internal_id = (1..existed_internal_ids.last.to_i + 1).without(existed_internal_ids).first

    @deal.internal_id = new_internal_id
  end

  def set_deadline
    @deal.deadline_at = Time.current + DEADLINE_IN_MUNUTES.minutes
  end

  def set_signature
    key = Eth::Key.new(priv: offer.token.signer_private_key_hex)
    deal.signature = key.personal_sign(contract)
  end

  def set_fee
    @deal.fee = offer.token.fee
  end

  def contract
    {
      id: @deal.internal_id,
      fee: @deal.fee,
      amt: @deal.locked,
      buyer: @deal.buyer&.eth_address,
      seller: @deal.seller&.eth_address,
      deadline: @deal.deadline_at.to_i
    }.to_json
  end
end
