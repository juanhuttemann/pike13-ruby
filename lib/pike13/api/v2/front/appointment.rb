# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class Appointment < Spyke::Base
          uri "front/appointments(/:id)"

          class << self
            def find_available_slots(service_id:, client:, **params)
              response = client.get("/front/appointments/#{service_id}/available_slots", params: params)
              response["available_slots"] || []
            end

            def available_slots_summary(service_id:, client:, **params)
              response = client.get("/front/appointments/#{service_id}/available_slots/summary", params: params)
              
              # Check if errors are present
              if response["errors"]
                errors = response["errors"]
                error_message = errors.is_a?(Array) ? errors.join(", ") : errors.to_s
                raise Pike13::ValidationError.new(
                  error_message,
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
