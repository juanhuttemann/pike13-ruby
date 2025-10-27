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
          end
        end
      end
    end
  end
end
