# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class PaymentTest < Minitest::Test
          def setup
            @client = default_client
          end

          def test_void_payment
            stub_pike13_request(:post, "/desk/payments/123/voids", response_body: {
                                  "payments" => [{
                                    "id" => 123,
                                    "description" => "Visa 1111, 1/20",
                                    "state" => "completed",
                                    "amount_cents" => 100,
                                    "voided_at" => "2025-10-25T00:00:00Z",
                                    "is_voidable" => false
                                  }]
                                })

            payment = Pike13::API::V2::Desk::Payment.void(
              client: @client,
              payment_id: 123,
              invoice_item_ids_to_cancel: [1, 2]
            )

            assert_equal 123, payment["id"]
            assert_equal "2025-10-25T00:00:00Z", payment["voided_at"]
            assert_equal false, payment["is_voidable"]
          end

          def test_configuration
            stub_pike13_request(:get, "/desk/payments/configuration", response_body: {
                                  "payment_configuration" => {
                                    "accepted_types" => ["creditcard", "check", "cash"],
                                    "creditcard" => {
                                      "accepted_card_types" => ["visa", "mastercard", "discover"],
                                      "required_fields" => {
                                        "cvv" => true,
                                        "address" => false
                                      }
                                    }
                                  }
                                })

            config = Pike13::API::V2::Desk::Payment.configuration(client: @client)

            assert_instance_of Hash, config
            assert_equal ["creditcard", "check", "cash"], config["accepted_types"]
            assert_equal ["visa", "mastercard", "discover"], config["creditcard"]["accepted_card_types"]
          end

          def test_void_payment_with_empty_invoice_items
            stub_pike13_request(:post, "/desk/payments/456/voids", response_body: {
                                  "payments" => [{
                                    "id" => 456,
                                    "state" => "completed",
                                    "voided_at" => "2025-10-25T12:00:00Z"
                                  }]
                                })

            payment = Pike13::API::V2::Desk::Payment.void(
              client: @client,
              payment_id: 456
            )

            assert_equal 456, payment["id"]
            assert_equal "2025-10-25T12:00:00Z", payment["voided_at"]
          end
        end
      end
    end
  end
end
