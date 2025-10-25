# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class Payment < Base
          uri "front/payments(/:id)"

          class << self
            # Get payment configuration
            #
            # @return [Hash] Configuration data
            #
            # @example
            #   config = Pike13::API::V2::Front::Payment.configuration
            def configuration
              response = connection.get("/api/v2/front/payments/configuration")
              # API returns {"payment_configuration": {...}}, Pike13JSONParser wraps singleton in array for non-single-resource GET
              data = response.body[:data]
              result = data.is_a?(Array) ? data.first || {} : data || {}
              result.deep_stringify_keys
            end
          end
        end
      end
    end
  end
end
