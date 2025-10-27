# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class PlanTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_all_plans
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/plans", response_body: {
                                  "plans" => [{ "id" => 1 }]
                                })

            plans = Pike13::API::V2::Desk::Plan.all

            assert_instance_of Hash, plans
            assert_equal 1, plans["plans"].size
            assert_instance_of Hash, plans["plans"].first
          end

          def test_find_plan
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/plans/123", response_body: {
                                  "plans" => [{ "id" => 123 }]
                                })

            plan = Pike13::API::V2::Desk::Plan.find(123)

            assert_instance_of Hash, plan
            assert_equal 123, plan["plans"].first["id"]
          end
        end
      end
    end
  end
end
