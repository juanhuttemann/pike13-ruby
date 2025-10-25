# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class Payment < Spyke::Base
          uri "front/payments(/:id)"

          class << self
            # Get payment configuration
            #
            # @param client [Pike13::Client] Client instance
            # @return [Hash] Configuration data
            #
            # @example
            #   config = Pike13::API::V2::Front::Payment.configuration(client: client)
            def configuration(client:)
              response = client.get("/front/payments/configuration")
              response["payment_configuration"] || {}
            end
          end
        end
      end
    end
  end
end
