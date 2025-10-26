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

            assert_instance_of Pike13::API::V2::Front::Plan, plan
            assert_equal 123, plan.id
          end

          def test_plan_terms
            plan = Pike13::API::V2::Front::Plan.new(id: 123)

            stub_pike13_request(:get, "https://test.pike13.com/api/v2/front/plans/123/plan_terms", response_body: {
                                  "plan_terms" => [{ "id" => 456 }]
                                })

            terms = plan.plan_terms

            assert_equal 1, terms.size
          end
        end
      end
    end
  end
end
