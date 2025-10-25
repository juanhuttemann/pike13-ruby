# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class InvoiceTest < Minitest::Test
          def setup
            @client = default_client
          end

          def test_all_invoices
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/invoices", response_body: {
                                  "invoices" => [
                                    { "id" => 1, "total_cents" => 5000 },
                                    { "id" => 2, "total_cents" => 10_000 }
                                  ]
                                })

            invoices = Pike13::API::V2::Desk::Invoice.all.to_a

            assert_instance_of Array, invoices
            assert_equal 2, invoices.size
            assert_instance_of Pike13::API::V2::Desk::Invoice, invoices.first
          end

          def test_find_invoice
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/invoices/123", response_body: {
                                  "invoices" => [{ "id" => 123, "total_cents" => 5000 }]
                                })

            invoice = Pike13::API::V2::Desk::Invoice.find(123)

            assert_instance_of Pike13::API::V2::Desk::Invoice, invoice
            assert_equal 123, invoice.id
          end

          def test_payment_methods
            invoice = Pike13::API::V2::Desk::Invoice.new(id: 123)

            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/invoices/123/payment_methods", response_body: {
                                  "payment_methods" => [{ "id" => 456, "type" => "credit_card" }]
                                })

            payment_methods = invoice.payment_methods

            assert_instance_of Array, payment_methods
            assert_equal 1, payment_methods.size
          end
        end
      end
    end
  end
end
