# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class SalesTax < Pike13::API::V2::Base
          @scope = "desk"
          @resource_name = "sales_taxes"
        end
      end
    end
  end
end
