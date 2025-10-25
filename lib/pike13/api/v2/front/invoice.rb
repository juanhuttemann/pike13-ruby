# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Front
        class Invoice < Spyke::Base
          uri "front/invoices(/:id)"
          include_root_in_json :invoice

          def payment_methods
            result = self.class.request(:get, "front/invoices/#{id}/payment_methods")
            result.data || []
          end
        end
      end
    end
  end
end
