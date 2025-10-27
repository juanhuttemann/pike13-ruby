# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class Invoice < Base
          class << self
            # GET /front/invoices
            def all
              client.get("front/invoices")
            end

            # GET /front/invoices/:id
            def find(id)
              client.get("front/invoices/#{id}")
            end

            # GET /front/invoices/:id/payment_methods
            def payment_methods(id)
              client.get("front/invoices/#{id}/payment_methods")
            end

            # POST /front/invoices
            def create(attributes)
              client.post("front/invoices", { invoice: attributes })
            end

            # PUT /front/invoices/:invoice_id
            def update(invoice_id, attributes)
              client.put("front/invoices/#{invoice_id}", { invoice: attributes })
            end

            # POST /front/invoices/:invoice_id/invoice_items
            def create_invoice_item(invoice_id, attributes)
              client.post("front/invoices/#{invoice_id}/invoice_items", { invoice_item: attributes })
            end

            # DELETE /front/invoices/:invoice_id/invoice_items/:id
            def destroy_invoice_item(invoice_id, id)
              client.delete("front/invoices/#{invoice_id}/invoice_items/#{id}")
            end

            # POST /front/invoices/:invoice_id/payments
            def create_payment(invoice_id, attributes)
              client.post("front/invoices/#{invoice_id}/payments", attributes)
            end

            # DELETE /front/invoices/:invoice_id/payments/:payment_id
            def destroy_payment(invoice_id, payment_id)
              client.delete("front/invoices/#{invoice_id}/payments/#{payment_id}")
            end
          end
        end
      end
    end
  end
end
