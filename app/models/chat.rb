# frozen_string_literal: true

class Chat < ApplicationRecord
  belongs_to :deal
  has_many :messages, dependent: :delete_all
end
