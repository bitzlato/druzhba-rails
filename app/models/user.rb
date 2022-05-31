# frozen_string_literal: true

class User < ApplicationRecord
  validates :eth_address, presence: true
end
