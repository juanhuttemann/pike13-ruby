# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Invoice < Base
          uri "desk/invoices(/:id)"
          include_root_in_json :invoice

          def payment_methods
            self.class.with("desk/invoices/#{id}/payment_methods").to_a
          end
        end
      end
    end
  end
end
