# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class PlanProduct < Base
          class << self
            # GET /front/plan_products
            def all
              client.get("front/plan_products")
            end

            # GET /front/plan_products/:id
            def find(id)
              client.get("front/plan_products/#{id}")
            end
          end
        end
      end
    end
  end
end
