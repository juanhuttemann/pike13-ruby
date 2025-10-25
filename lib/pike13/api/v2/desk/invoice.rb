# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        class Invoice < Spyke::Base
          uri "desk/invoices(/:id)"
          include_root_in_json :invoice

          # TODO: Add payment_methods association if PaymentMethod model exists
        end
      end
    end
  end
end
