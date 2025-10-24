# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class Appointment
          class << self
            # Find available appointment slots for a service
            #
            # @param service_id [Integer] Service ID
            # @param client [Pike13::Client] Client client
            # @param params [Hash] Query parameters (date, location_ids, staff_member_ids, etc.)
            # @return [Array<Hash>] Array of available slots
            #
            # @example
            #   Pike13::API::V2::Front::Appointment.find_available_slots(
            #     service_id: 123,
            #     client: client,
            #     date: '2015-09-01',
            #     location_ids: '1,2',
            #     staff_member_ids: '1,2'
            #   )
            def find_available_slots(service_id:, client:, **params)
              path = "/front/appointments/#{service_id}/available_slots"
              response = client.get(path, params: params)
              response["available_slots"] || []
            end

            # Get availability summary (heat map) for a service
            #
            # Returns availability scores for the given date range (from/to parameters).
            # The score for each day is the percentage of availability relative to the day
            # with the most availability. Days with a score of 1 have the most availability
            # while days with a score closer to 0 have less. Date range is limited to 90 days.
            #
            # @param service_id [Integer] Service ID
            # @param client [Pike13::Client] Client client
            # @param params [Hash] Query parameters (from, to, location_ids, staff_member_ids, etc.)
            # @return [Hash] Summary of available slots by date
            #
            # @example
            #   Pike13::API::V2::Front::Appointment.available_slots_summary(
            #     service_id: 123,
            #     client: client,
            #     from: '2020-01-01',
            #     to: '2020-02-10',
            #     staff_member_ids: '56',
            #     location_ids: '2,8'
            #   )
            def available_slots_summary(service_id:, client:, **params)
              path = "/front/appointments/#{service_id}/available_slots/summary"
              response = client.get(path, params: params)

              # Handle API-level errors (e.g., date range exceeds 90 days)
              if response.key?("errors")
                raise Pike13::ValidationError.new(
                  response["errors"].join(", "),
                  http_status: 422,
                  response_body: response
                )
              end

              response
            end
          end
        end
      end
    end
  end
end
