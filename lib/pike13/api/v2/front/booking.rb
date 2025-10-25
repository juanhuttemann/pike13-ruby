# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class Booking < Spyke::Base
          uri "front/bookings(/:id)"
          include_root_in_json :booking

          class << self
            def find_lease(booking_id:, id:, **params)
              result = with("front/bookings/#{booking_id}/leases/#{id}").where(params).get
              result.data["leases"]&.first || {}
            end
          end
        end
      end
    end
  end
end
