# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Invoice < Base
          class << self
            # GET /desk/invoices
            def all
              client.get("desk/invoices")
            end

            # GET /desk/invoices/:id
            def find(id)
              client.get("desk/invoices/#{id}")
            end

            # GET /desk/invoices/:id/payment_methods
            def payment_methods(id)
              client.get("desk/invoices/#{id}/payment_methods")
            end

            # POST /desk/invoices
            def create(attributes)
              client.post("desk/invoices", { invoice: attributes })
            end

            # PUT /desk/invoices/:invoice_id
            def update(invoice_id, attributes)
              client.put("desk/invoices/#{invoice_id}", { invoice: attributes })
            end

            # POST /desk/invoices/:invoice_id/invoice_items
            def create_invoice_item(invoice_id, attributes)
              client.post("desk/invoices/#{invoice_id}/invoice_items", { invoice_item: attributes })
            end

            # DELETE /desk/invoices/:invoice_id/invoice_items/:id
            def destroy_invoice_item(invoice_id, id)
              client.delete("desk/invoices/#{invoice_id}/invoice_items/#{id}")
            end

            # POST /desk/invoices/:invoice_id/invoice_items/:invoice_item_id/discounts
            def create_discount(invoice_id, invoice_item_id, attributes)
              client.post("desk/invoices/#{invoice_id}/invoice_items/#{invoice_item_id}/discounts", attributes)
            end

            # GET /desk/invoices/:invoice_id/invoice_items/:invoice_item_id/discounts
            def discounts(invoice_id, invoice_item_id)
              client.get("desk/invoices/#{invoice_id}/invoice_items/#{invoice_item_id}/discounts")
            end

            # DELETE /desk/invoices/:invoice_id/invoice_items/:invoice_item_id/discounts
            def destroy_discounts(invoice_id, invoice_item_id)
              client.delete("desk/invoices/#{invoice_id}/invoice_items/#{invoice_item_id}/discounts")
            end

            # POST /desk/invoices/:invoice_id/invoice_items/:invoice_item_id/prorates
            def create_prorate(invoice_id, invoice_item_id, attributes)
              client.post("desk/invoices/#{invoice_id}/invoice_items/#{invoice_item_id}/prorates", attributes)
            end

            # DELETE /desk/invoices/:invoice_id/invoice_items/:invoice_item_id/prorates
            def destroy_prorate(invoice_id, invoice_item_id)
              client.delete("desk/invoices/#{invoice_id}/invoice_items/#{invoice_item_id}/prorates")
            end

            # POST /desk/invoices/:invoice_id/payments
            def create_payment(invoice_id, attributes)
              client.post("desk/invoices/#{invoice_id}/payments", attributes)
            end

            # POST /desk/invoices/:invoice_id/payments/:payment_id/refunds
            def create_refund(invoice_id, payment_id, attributes)
              client.post("desk/invoices/#{invoice_id}/payments/#{payment_id}/refunds", attributes)
            end
          end
        end
      end
    end
  end
end
