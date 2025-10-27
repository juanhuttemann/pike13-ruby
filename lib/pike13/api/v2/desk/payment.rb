# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Payment < Base
          class << self
            # GET /desk/payments/:id
            def find(id)
              client.get("desk/payments/#{id}")
            end

            # POST /desk/payments/:payment_id/voids
            def void(payment_id:, invoice_item_ids_to_cancel: [])
              body = { void: {} }
              body[:void][:invoice_item_ids_to_cancel] = invoice_item_ids_to_cancel if invoice_item_ids_to_cancel.any?

              client.post("desk/payments/#{payment_id}/voids", body)
            end

            # GET /desk/payments/configuration
            def configuration
              response = client.get("desk/payments/configuration")
              response.is_a?(Array) ? response.first : response
            end
          end
        end
      end
    end
  end
end
