# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class SalesTax < Base
          uri "desk/sales_taxes(/:id)"
          include_root_in_json :sales_tax
        end
      end
    end
  end
end
