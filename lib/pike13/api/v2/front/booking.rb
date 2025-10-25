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
              result = request(:get, "front/bookings/#{booking_id}/leases/#{id}", params)
              # result.data is already a Hash (not an array) for single resource endpoints
              result.data.is_a?(Hash) ? result.data.stringify_keys : {}
            end
          end
        end
      end
    end
  end
end
