# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Front
        class PaymentTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_configuration
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/front/payments/configuration",
                                response_body: {
                                  "payment_configuration" => {
                                    "accepted_types" => %w[creditcard check],
                                    "creditcard" => {
                                      "accepted_card_types" => %w[visa mastercard],
                                      "required_fields" => {
                                        "cvv" => true,
                                        "address" => false,
                                        "postal_code" => true
                                      }
                                    }
                                  }
                                })

            result = Pike13::API::V2::Front::Payment.configuration

            config = result["payment_configuration"] || result

            assert_equal %w[creditcard check], config["accepted_types"]
            assert config["creditcard"]["required_fields"]["cvv"]
            refute config["creditcard"]["required_fields"]["address"]
          end

          def test_configuration_with_ach
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/front/payments/configuration", response_body: {
                                  "payment_configuration" => {
                                    "accepted_types" => %w[creditcard ach],
                                    "creditcard" => {
                                      "accepted_card_types" => ["visa"],
                                      "required_fields" => { "cvv" => false }
                                    }
                                  }
                                })

            result = Pike13::API::V2::Front::Payment.configuration

            config = result["payment_configuration"] || result

            assert_includes config["accepted_types"], "ach"
            refute config["creditcard"]["required_fields"]["cvv"]
          end
        end
      end
    end
  end
end
