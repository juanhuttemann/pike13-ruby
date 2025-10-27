# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class FormOfPaymentTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_all
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/people/123/form_of_payments", response_body: {
                                  "form_of_payments" => [{ "id" => 1, "type" => "creditcard" }]
                                })

            result = Pike13::API::V2::Desk::FormOfPayment.all(person_id: 123)

            assert_instance_of Hash, result
            assert_equal 1, result["form_of_payments"].first["id"]
          end

          def test_find
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/people/123/form_of_payments/456", response_body: {
                                  "form_of_payments" => [{ "id" => 456, "type" => "creditcard" }]
                                })

            result = Pike13::API::V2::Desk::FormOfPayment.find(person_id: 123, id: 456)

            assert_instance_of Hash, result
            assert_equal 456, result["form_of_payments"].first["id"]
          end

          def test_create
            stub_pike13_request(:post, "https://test.pike13.com/api/v2/desk/people/123/form_of_payments", response_body: {
                                  "form_of_payments" => [{ "id" => 789, "type" => "creditcard" }]
                                })

            result = Pike13::API::V2::Desk::FormOfPayment.create(person_id: 123, attributes: { type: "creditcard" })

            assert_instance_of Hash, result
            assert_equal 789, result["form_of_payments"].first["id"]
          end

          def test_update
            stub_pike13_request(:put, "https://test.pike13.com/api/v2/desk/people/123/form_of_payments/456", response_body: {
                                  "form_of_payments" => [{ "id" => 456, "autobill" => true }]
                                })

            result = Pike13::API::V2::Desk::FormOfPayment.update(person_id: 123, id: 456,
                                                                 attributes: { autobill: true })

            assert_instance_of Hash, result
            assert_equal true, result["form_of_payments"].first["autobill"]
          end

          def test_destroy
            stub_pike13_request(:delete, "https://test.pike13.com/api/v2/desk/people/123/form_of_payments/456",
                                response_body: {})

            result = Pike13::API::V2::Desk::FormOfPayment.destroy(person_id: 123, id: 456)

            assert_instance_of Hash, result
          end
        end
      end
    end
  end
end
