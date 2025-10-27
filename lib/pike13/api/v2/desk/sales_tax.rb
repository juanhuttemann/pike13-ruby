# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class SalesTax < Base
          class << self
            # GET /desk/sales_taxes
            def all
              client.get("desk/sales_taxes")
            end

            # GET /desk/sales_taxes/:id
            def find(id)
              client.get("desk/sales_taxes/#{id}")
            end
          end
        end
      end
    end
  end
end
