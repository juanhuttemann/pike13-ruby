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
            stub_pike13_request(:get, "/desk/plans", scope: "desk", response_body: {
                                  "plans" => [{ "id" => 1 }]
                                })

            items = @client.desk.plans.all

            assert_equal 1, items.size
          end

          def test_find_plan
            stub_pike13_request(:get, "/desk/plans/123", scope: "desk", response_body: {
                                  "plans" => [{ "id" => 123 }]
                                })

            item = @client.desk.plans.find(123)

            assert_equal 123, item.id
          end
        end
      end
    end
  end
end
