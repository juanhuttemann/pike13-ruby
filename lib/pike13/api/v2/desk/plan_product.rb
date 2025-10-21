# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class PlanProduct < Pike13::API::V2::Base
          @scope = "desk"
          @resource_name = "plan_products"
        end
      end
    end
  end
end
