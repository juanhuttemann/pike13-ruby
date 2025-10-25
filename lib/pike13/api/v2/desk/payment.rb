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

              response = connection.post("/api/v2/desk/payments/#{payment_id}/voids") do |req|
                req.body = body.to_json
              end
              # API returns {"payments": [...]}, Pike13JSONParser unwraps for POST to single hash
              (response.body[:data] || {}).deep_stringify_keys
            end

            # Get payment configuration
            #
            # @return [Hash] Configuration data
            #
            # @example
            #   config = Pike13::API::V2::Desk::Payment.configuration
            def configuration
              response = connection.get("/api/v2/desk/payments/configuration")
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
