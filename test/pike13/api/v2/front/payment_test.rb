# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Front
        class PaymentTest < Minitest::Test
          def setup
            @client = default_client
          end

          def test_configuration
            stub_pike13_request(:get, "/front/payments/configuration", response_body: {
                                  "payment_configuration" => {
                                    "accepted_types" => ["creditcard", "check"],
                                    "creditcard" => {
                                      "accepted_card_types" => ["visa", "mastercard"],
                                      "required_fields" => {
                                        "cvv" => true,
                                        "address" => false,
                                        "postal_code" => true
                                      }
                                    }
                                  }
                                })

            config = @client.front.payments.configuration(client: @client)

            assert_instance_of Hash, config
            assert_equal ["creditcard", "check"], config["accepted_types"]
            assert config["creditcard"]["required_fields"]["cvv"]
            refute config["creditcard"]["required_fields"]["address"]
          end

          def test_configuration_with_ach
            stub_pike13_request(:get, "/front/payments/configuration", response_body: {
                                  "payment_configuration" => {
                                    "accepted_types" => ["creditcard", "ach"],
                                    "creditcard" => {
                                      "accepted_card_types" => ["visa"],
                                      "required_fields" => { "cvv" => false }
                                    }
                                  }
                                })

            config = @client.front.payments.configuration(client: @client)

            assert_includes config["accepted_types"], "ach"
            refute config["creditcard"]["required_fields"]["cvv"]
          end
        end
      end
    end
  end
end
