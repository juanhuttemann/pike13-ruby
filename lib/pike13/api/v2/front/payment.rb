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
              result = request(:get, "front/payments/configuration", {})
              data = result.data
              result_data = data.is_a?(Array) ? data.first || {} : data || {}
              result_data.deep_stringify_keys.to_h
            end
          end
        end
      end
    end
  end
end
