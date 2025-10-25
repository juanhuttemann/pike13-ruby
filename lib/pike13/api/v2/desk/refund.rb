# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Refund < Spyke::Base
          uri "desk/refunds(/:id)"

          class << self
            # Void a refund
            #
            # @param client [Pike13::Client] Client instance
            # @param refund_id [Integer] Refund ID
            # @return [Hash] Refund data
            #
            # @example
            #   refund = Pike13::API::V2::Desk::Refund.void(
            #     client: client,
            #     refund_id: 123
            #   )
            def void(client:, refund_id:)
              response = client.post("/desk/refunds/#{refund_id}/voids")
              response["refunds"]&.first || {}
            end
          end
        end
      end
    end
  end
end
