# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Payment < Spyke::Base
          uri "desk/payments(/:id)"

          class << self
            # Void a payment
            #
            # @param client [Pike13::Client] Client instance
            # @param payment_id [Integer] Payment ID
            # @param invoice_item_ids_to_cancel [Array<Integer>] Optional invoice items to cancel
            # @return [Hash] Payment data
            #
            # @example
            #   payment = Pike13::API::V2::Desk::Payment.void(
            #     client: client,
            #     payment_id: 123,
            #     invoice_item_ids_to_cancel: [1, 2]
            #   )
            def void(client:, payment_id:, invoice_item_ids_to_cancel: [])
              body = { void: {} }
              body[:void][:invoice_item_ids_to_cancel] = invoice_item_ids_to_cancel if invoice_item_ids_to_cancel.any?

              response = client.post("/desk/payments/#{payment_id}/voids", body: body)
              response["payments"]&.first || {}
            end

            # Get payment configuration
            #
            # @param client [Pike13::Client] Client instance
            # @return [Hash] Configuration data
            #
            # @example
            #   config = Pike13::API::V2::Desk::Payment.configuration(client: client)
            def configuration(client:)
              response = client.get("/desk/payments/configuration")
              response["payment_configuration"] || {}
            end
          end
        end
      end
    end
  end
end
