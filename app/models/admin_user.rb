# frozen_string_literal: true

class AdminUser < ApplicationRecord
  authenticates_with_sorcery!
end
