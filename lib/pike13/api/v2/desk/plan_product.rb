# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class PlanProduct < Spyke::Base
          uri "desk/plan_products(/:id)"
          include_root_in_json :plan_product
        end
      end
    end
  end
end
