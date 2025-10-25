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
            # @param refund_id [Integer] Refund ID
            # @return [Hash] Refund data
            #
            # @example
            #   refund = Pike13::API::V2::Desk::Refund.void(
            #     refund_id: 123
            #   )
            def void(refund_id:)
              response = connection.post("/api/v2/desk/refunds/#{refund_id}/voids")
              # API returns {"refunds": [...]}, Pike13JSONParser unwraps for POST to single hash
              (response.body[:data] || {}).deep_stringify_keys
            end
          end
        end
      end
    end
  end
end
