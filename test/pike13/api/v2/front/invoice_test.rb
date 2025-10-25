# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Front
        class InvoiceTest < Minitest::Test
          def setup
            @client = default_client
          end

          def test_find_invoice
            stub_pike13_request(:get, "/front/invoices/123", response_body: {
                                  "invoices" => [{ "id" => 123 }]
                                })

            invoice = @client.front.invoices.find(123)

            assert_instance_of Pike13::API::V2::Front::Invoice, invoice
            assert_equal 123, invoice.id
          end

          def test_payment_methods
            invoice = Pike13::API::V2::Front::Invoice.new(client: @client, id: 123)

            stub_pike13_request(:get, "/front/invoices/123/payment_methods", response_body: {
                                  "payment_methods" => [{ "id" => 456 }]
                                })

            payment_methods = invoice.payment_methods

            assert_equal 1, payment_methods.size
          end
        end
      end
    end
  end
end
