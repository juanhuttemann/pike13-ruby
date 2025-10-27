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
          end
        end
      end
    end
  end
end
