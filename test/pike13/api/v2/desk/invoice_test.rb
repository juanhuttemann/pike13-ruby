# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class InvoiceTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_all_invoices
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/invoices", response_body: {
                                  "invoices" => [
                                    { "id" => 1, "total_cents" => 5000 },
                                    { "id" => 2, "total_cents" => 10_000 }
                                  ]
                                })

            invoices = Pike13::API::V2::Desk::Invoice.all

            assert_instance_of Hash, invoices
            assert_equal 2, invoices["invoices"].size
            assert_instance_of Hash, invoices["invoices"].first
          end

          def test_find_invoice
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/invoices/123", response_body: {
                                  "invoices" => [{ "id" => 123, "total_cents" => 5000 }]
                                })

            invoice = Pike13::API::V2::Desk::Invoice.find(123)

            assert_instance_of Hash, invoice
            assert_equal 123, invoice["invoices"].first["id"]
          end

          # NOTE: Instance-based associations not supported - use class methods instead
        end
      end
    end
  end
end
