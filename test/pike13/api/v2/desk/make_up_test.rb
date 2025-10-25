# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class MakeUpTest < Minitest::Test
          def setup
            @client = default_client
          end

          def test_reasons
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/make_ups/reasons", response_body: {
                                  "make_up_reasons" => [
                                    { "id" => 1, "name" => "Illness", "description" => "Student was ill" },
                                    { "id" => 2, "name" => "Weather", "description" => "Bad weather conditions" }
                                  ]
                                })

            reasons = Pike13::API::V2::Desk::MakeUp.reasons

            assert_instance_of Array, reasons
            assert_equal 2, reasons.size
            assert_equal 1, reasons.first["id"]
            assert_equal "Illness", reasons.first["name"]
          end

          def test_generate
            stub_pike13_request(:post, "https://test.pike13.com/api/v2/desk/make_ups/generate", response_body: {
                                  "make_up" => {
                                    "id" => 1,
                                    "make_up_reason_id" => 1,
                                    "free_form_reason" => "Student had the flu",
                                    "staff_mode" => true
                                  }
                                })

            make_up = Pike13::API::V2::Desk::MakeUp.generate(
              visit_id: 123,
              make_up_reason_id: 1,
              free_form_reason: "Student had the flu"
            )

            assert_equal 1, make_up["id"]
            assert_equal 1, make_up["make_up_reason_id"]
            assert_equal "Student had the flu", make_up["free_form_reason"]
            assert make_up["staff_mode"]
          end

          def test_generate_without_free_form_reason
            stub_pike13_request(:post, "https://test.pike13.com/api/v2/desk/make_ups/generate", response_body: {
                                  "make_up" => {
                                    "id" => 2,
                                    "make_up_reason_id" => 2,
                                    "free_form_reason" => nil,
                                    "staff_mode" => true
                                  }
                                })

            make_up = Pike13::API::V2::Desk::MakeUp.generate(
              visit_id: 456,
              make_up_reason_id: 2
            )

            assert_equal 2, make_up["id"]
            assert_equal 2, make_up["make_up_reason_id"]
            assert_nil make_up["free_form_reason"]
          end
        end
      end
    end
  end
end
