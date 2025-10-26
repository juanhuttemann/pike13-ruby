# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Payment < Base
          uri "desk/payments(/:id)"

          class << self
            # Void a payment
            #
            # @param payment_id [Integer] Payment ID
            # @param invoice_item_ids_to_cancel [Array<Integer>] Optional invoice items to cancel
            # @return [Hash] Payment data
            #
            # @example
            #   payment = Pike13::API::V2::Desk::Payment.void(
            #     payment_id: 123,
            #     invoice_item_ids_to_cancel: [1, 2]
            #   )
            def void(payment_id:, invoice_item_ids_to_cancel: [])
              body = { void: {} }
              body[:void][:invoice_item_ids_to_cancel] = invoice_item_ids_to_cancel if invoice_item_ids_to_cancel.any?

              result = request(:post, "desk/payments/#{payment_id}/voids", body)
              (result.data || {}).deep_stringify_keys
            end

            # Get payment configuration
            #
            # @return [Hash] Configuration data
            #
            # @example
            #   config = Pike13::API::V2::Desk::Payment.configuration
            def configuration
              result = request(:get, "desk/payments/configuration", {})
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
