# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class RevenueCategory < Base
          class << self
            # GET /desk/revenue_categories
            def all
              client.get("desk/revenue_categories")
            end

            # GET /desk/revenue_categories/:id
            def find(id)
              client.get("desk/revenue_categories/#{id}")
            end
          end
        end
      end
    end
  end
end
