# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class PunchTest < Minitest::Test
          def setup
            @client = default_client
          end

          def test_find_punch
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/punches/123", response_body: {
                                  "punches" => [{ "id" => 123 }]
                                })

            punch = Pike13::API::V2::Desk::Punch.find(123)

            assert_instance_of Pike13::API::V2::Desk::Punch, punch
            assert_equal 123, punch.id
          end
        end
      end
    end
  end
end
