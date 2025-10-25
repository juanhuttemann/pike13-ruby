# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Appointment < Spyke::Base
          uri "desk/appointments(/:id)"

          class << self
            def find_available_slots(service_id:, **params)
              result = request(:get, "desk/appointments/#{service_id}/available_slots", params)
              # Pike13JSONParser extracts "available_slots" and puts it in data
              result.data || []
            end

            def available_slots_summary(service_id:, **params)
              result = request(:get, "desk/appointments/#{service_id}/available_slots/summary", params)

              # This endpoint returns raw data without a resource wrapper
              # Pike13JSONParser misinterprets the first date key as the resource key
              # Build response hash from result - it will have each date as an attribute
              response_hash = {}
              result.instance_variables.each do |ivar|
                key = ivar.to_s.delete("@")
                value = result.instance_variable_get(ivar)
                response_hash[key] = value unless %w[metadata errors uri attributes].include?(key)
              end

              # Check if errors are present
              if response_hash["errors"]
                raise Pike13::ValidationError.new(
                  response_hash["errors"].join(", "),
                  http_status: 422,
                  response_body: response_hash
                )
              end

              response_hash
            end
          end
        end
      end
    end
  end
end
