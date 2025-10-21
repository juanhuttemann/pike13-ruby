# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Booking < Pike13::API::V2::FindOnlyResource
          @scope = "desk"
          @resource_name = "bookings"
        end
      end
    end
  end
end
