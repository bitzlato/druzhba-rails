# frozen_string_literal: true

module Daemons
  class FinishDeadlineDraftDeals < Base
    @sleep_time = 1.minute.to_i

    def process
      Deal.draft_to_finish.find_each do |deal|
        deal.update!(finished: true)
      end
    end
  end
end
