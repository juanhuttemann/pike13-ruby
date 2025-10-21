# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Invoice < Pike13::API::V2::Base
          @scope = "desk"
          @resource_name = "invoices"

          # Nested resource methods using has_many DSL
          has_many :payment_methods
        end
      end
    end
  end
end
