# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class PunchTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_find_punch
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/punches/123", response_body: {
                                  "punches" => [{ "id" => 123 }]
                                })

            punch = Pike13::API::V2::Desk::Punch.find(123)

            assert_instance_of Hash, punch
            assert_equal 123, punch["punches"].first["id"]
          end

          def test_create_punch
            stub_pike13_request(:post, "https://test.pike13.com/api/v2/desk/punches",
                                response_body: {
                                  "punches" => [{ "id" => 456, "pack_id" => 123, "visit_id" => 789 }]
                                })

            result = Pike13::API::V2::Desk::Punch.create(
              pack_id: 123,
              visit_id: 789
            )

            assert_instance_of Hash, result
            assert_equal 456, result["punches"].first["id"]
            assert_equal 123, result["punches"].first["pack_id"]
          end

          def test_destroy_punch
            stub_pike13_request(:delete, "https://test.pike13.com/api/v2/desk/punches/456",
                                response_body: {})

            result = Pike13::API::V2::Desk::Punch.destroy(456)

            assert_instance_of Hash, result
          end
        end
      end
    end
  end
end
