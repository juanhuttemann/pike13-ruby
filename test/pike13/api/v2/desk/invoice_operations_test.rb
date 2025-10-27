# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class InvoiceOperationsTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_create_invoice
            stub_pike13_request(:post, "https://test.pike13.com/api/v2/desk/invoices", response_body: {
                                  "invoices" => [{ "id" => 123, "state" => "cart" }]
                                })

            result = Pike13::API::V2::Desk::Invoice.create({ plan_products: [] })

            assert_instance_of Hash, result
            assert_equal 123, result["invoices"].first["id"]
          end

          def test_update_invoice
            stub_pike13_request(:put, "https://test.pike13.com/api/v2/desk/invoices/123", response_body: {
                                  "invoices" => [{ "id" => 123, "state" => "closed" }]
                                })

            result = Pike13::API::V2::Desk::Invoice.update(123, { state_event: "close" })

            assert_instance_of Hash, result
            assert_equal "closed", result["invoices"].first["state"]
          end

          def test_create_invoice_item
            stub_pike13_request(:post, "https://test.pike13.com/api/v2/desk/invoices/123/invoice_items", response_body: {
                                  "invoice_items" => [{ "id" => 456 }]
                                })

            result = Pike13::API::V2::Desk::Invoice.create_invoice_item(123, { plan_product: { id: 10 } })

            assert_instance_of Hash, result
            assert_equal 456, result["invoice_items"].first["id"]
          end

          def test_destroy_invoice_item
            stub_pike13_request(:delete, "https://test.pike13.com/api/v2/desk/invoices/123/invoice_items/456",
                                response_body: {})

            result = Pike13::API::V2::Desk::Invoice.destroy_invoice_item(123, 456)

            assert_instance_of Hash, result
          end

          def test_create_payment
            stub_pike13_request(:post, "https://test.pike13.com/api/v2/desk/invoices/123/payments", response_body: {
                                  "payments" => [{ "id" => 789, "state" => "completed" }]
                                })

            result = Pike13::API::V2::Desk::Invoice.create_payment(123, { payments: [{ payment_method: "cash" }] })

            assert_instance_of Hash, result
            assert_equal 789, result["payments"].first["id"]
          end

          def test_create_refund
            stub_pike13_request(:post, "https://test.pike13.com/api/v2/desk/invoices/123/payments/789/refunds", response_body: {
                                  "refunds" => [{ "id" => 999, "state" => "completed" }]
                                })

            result = Pike13::API::V2::Desk::Invoice.create_refund(123, 789, { refund: { amount_cents: 1000 } })

            assert_instance_of Hash, result
            assert_equal 999, result["refunds"].first["id"]
          end
        end
      end
    end
  end
end
