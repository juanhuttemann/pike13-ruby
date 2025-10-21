# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Front
        class PlanProductTest < Minitest::Test
          def setup
            @client = default_client
          end

          def test_all_plan_products
            stub_pike13_request(:get, "/front/plan_products", scope: "front", response_body: {
                                  "plan_products" => [{ "id" => 1 }]
                                })

            items = @client.front.plan_products.all

            assert_equal 1, items.size
          end

          def test_find_plan_product
            stub_pike13_request(:get, "/front/plan_products/123", scope: "front", response_body: {
                                  "plan_products" => [{ "id" => 123 }]
                                })

            item = @client.front.plan_products.find(123)

            assert_equal 123, item.id
          end
        end
      end
    end
  end
end
