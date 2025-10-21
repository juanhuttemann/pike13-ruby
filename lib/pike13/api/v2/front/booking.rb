# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class Booking < Pike13::API::V2::FindOnlyResource
          @scope = "front"
          @resource_name = "bookings"

          # Get a specific lease for a booking
          #
          # @param booking_id [Integer] Booking ID
          # @param id [Integer] Lease ID
          # @param session [Pike13::Client] Client session
          # @param params [Hash] Query parameters (filters, etc.)
          # @return [Hash] Lease details
          #
          # @example
          #   Pike13::API::V2::Front::Booking.find_lease(booking_id: 123, id: 456, session: client)
          def self.find_lease(booking_id:, id:, session:, **params)
            path = "/#{scope}/#{resource_name}/#{booking_id}/leases/#{id}"
            response = session.http_client.get(path, params: params, scoped: scoped?)
            response["leases"]&.first || {}
          end
        end
      end
    end
  end
end
