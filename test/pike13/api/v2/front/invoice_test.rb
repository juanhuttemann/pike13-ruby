# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Front
        class InvoiceTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_find_invoice
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/front/invoices/123", response_body: {
                                  "invoices" => [{ "id" => 123 }]
                                })

            invoice = Pike13::API::V2::Front::Invoice.find(123)

            assert_instance_of Hash, invoice
            assert_equal 123, invoice["invoices"].first["id"]
          end

          # NOTE: Instance-based associations not supported - use class methods instead
        end
      end
    end
  end
end
