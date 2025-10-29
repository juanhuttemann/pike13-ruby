# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class PlanProduct < Base
          class << self
            # GET /desk/plan_products
            def all(**params)
              client.get("desk/plan_products", params)
            end

            # GET /desk/plan_products/:id
            def find(id)
              client.get("desk/plan_products/#{id}")
            end
          end
        end
      end
    end
  end
end
