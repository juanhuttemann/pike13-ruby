# frozen_string_literal: true

require_relative "../../../../pike13/middleware/passthrough_json_parser"

module Pike13
  module API
    module V2
      module Front
        class Appointment < Base
          uri "front/appointments(/:id)"

          def self.find_available_slots(service_id:, **params)
            with("front/appointments/#{service_id}/available_slots").where(params).to_a
          end

          def self.available_slots_summary(service_id:, **params)
            # Use passthrough parser for flat hash response
            temp_conn = passthrough_connection
            original_conn = connection
            self.connection = temp_conn

            result = request(:get, "front/appointments/#{service_id}/available_slots/summary", params)

            self.connection = original_conn
            raise Pike13::ValidationError.new(result.errors.join(", "), http_status: 422) if result.errors.any?

            result.data
          end

          private_class_method def self.passthrough_connection
            Faraday.new(url: connection.url_prefix.to_s) do |c|
              c.request :retry, max: 2, interval: 0.5, backoff_factor: 2
              c.request :json
              c.use Pike13::Middleware::PassthroughJSONParser
              c.response :json, content_type: /\bjson$/
              c.headers["Authorization"] = connection.headers["Authorization"]
              c.adapter Faraday.default_adapter
            end
          end
        end
      end
    end
  end
end
