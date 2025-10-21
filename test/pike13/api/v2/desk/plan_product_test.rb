# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class PlanProductTest < Minitest::Test
          def setup
            @client = default_client
          end

          def test_all_plan_products
            stub_pike13_request(:get, "/desk/plan_products", scope: "desk", response_body: {
                                  "plan_products" => [{ "id" => 1 }]
                                })

            items = @client.desk.plan_products.all

            assert_equal 1, items.size
          end

          def test_find_plan_product
            stub_pike13_request(:get, "/desk/plan_products/123", scope: "desk", response_body: {
                                  "plan_products" => [{ "id" => 123 }]
                                })

            item = @client.desk.plan_products.find(123)

            assert_equal 123, item.id
          end
        end
      end
    end
  end
end
