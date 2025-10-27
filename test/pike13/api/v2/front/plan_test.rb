# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Front
        class PlanTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_find_plan
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/front/plans/123", response_body: {
                                  "plans" => [{ "id" => 123 }]
                                })

            plan = Pike13::API::V2::Front::Plan.find(123)

            assert_instance_of Hash, plan
            assert_equal 123, plan["plans"].first["id"]
          end

          # NOTE: Instance-based associations not supported - use class methods instead
        end
      end
    end
  end
end
