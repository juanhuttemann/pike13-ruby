# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class Appointment < Spyke::Base
          uri "front/appointments(/:id)"

          class << self
            def find_available_slots(service_id:, **params)
              url = "/api/v2/front/appointments/#{service_id}/available_slots"
              url += "?#{URI.encode_www_form(params)}" if params.any?
              response = connection.get(url)
              # API returns {"available_slots": [...]}, Pike13JSONParser extracts this as data array
              (response.body[:data] || []).map(&:deep_stringify_keys)
            end

            def available_slots_summary(service_id:, **params)
              url = "/api/v2/front/appointments/#{service_id}/available_slots/summary"
              url += "?#{URI.encode_www_form(params)}" if params.any?
              response = connection.get(url)
              body = response.body
              
              # Check if errors are present
              errors = body[:errors]
              if errors && errors.any?
                error_message = errors.is_a?(Array) ? errors.join(", ") : errors.to_s
                raise Pike13::ValidationError.new(
                  error_message,
                  http_status: 422,
                  response_body: body
                )
              end
              
              # API returns flat hash like {"2020-01-17": 1.0, ...}, no resource wrapper
              # Pike13JSONParser treats first key as resource, extracts its value to data
              # Need to reconstruct: metadata has all but first key, data has first value
              result = body[:metadata]&.deep_stringify_keys || {}
              # If data is present and is an array with a single value, it's the extracted first entry
              if body[:data].is_a?(Array) && body[:data].size == 1
                # Try to infer the missing key - it should be the earliest date
                # Find all date-like keys in metadata
                date_keys = result.keys.select { |k| k.match?(/^\d{4}-\d{2}-\d{2}$/) }.sort
                if date_keys.any?
                  # The missing key is one day before the first key in metadata
                  first_meta_date = Date.parse(date_keys.first)
                  missing_date = (first_meta_date - 1).to_s
                  result[missing_date] = body[:data].first
                end
              end
              result
            end
          end
        end
      end
    end
  end
end
