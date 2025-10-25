# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class PlanTest < Minitest::Test
          def setup
            @client = default_client
          end

          def test_all_plans
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/plans", response_body: {
                                  "plans" => [{ "id" => 1 }]
                                })

            plans = @client.desk.plans.all.to_a

            assert_instance_of Array, plans
            assert_equal 1, plans.size
            assert_instance_of Pike13::API::V2::Desk::Plan, plans.first
          end

          def test_find_plan
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/plans/123", response_body: {
                                  "plans" => [{ "id" => 123 }]
                                })

            plan = @client.desk.plans.find(123)

            assert_instance_of Pike13::API::V2::Desk::Plan, plan
            assert_equal 123, plan.id
          end
        end
      end
    end
  end
end
