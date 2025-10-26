# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Refund < Base
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
              result = request(:post, "desk/refunds/#{refund_id}/voids", {})
              (result.data || {}).deep_stringify_keys
            end
          end
        end
      end
    end
  end
end
