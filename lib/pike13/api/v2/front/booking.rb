# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class Booking < Pike13::API::V2::IdOnlyResource
          @resource_name = "bookings"

          # Get a specific lease for a booking
          #
          # @param booking_id [Integer] Booking ID
          # @param id [Integer] Lease ID
          # @param client [Pike13::Client] Client client
          # @param params [Hash] Query parameters (filters, etc.)
          # @return [Hash] Lease details
          #
          # @example
          #   Pike13::API::V2::Front::Booking.find_lease(booking_id: 123, id: 456, client: client)
          def self.find_lease(booking_id:, id:, client:, **params)
            path = "/#{scope}/#{resource_name}/#{booking_id}/leases/#{id}"
            response = client.get(path, params: params)
            response["leases"]&.first || {}
          end
        end
      end
    end
  end
end
