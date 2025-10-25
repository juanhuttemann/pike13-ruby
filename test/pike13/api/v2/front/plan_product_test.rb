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
            stub_pike13_request(:get, "/front/plan_products", response_body: {
                                  "plan_products" => [{ "id" => 1 }]
                                })

            plan_products = @client.front.plan_products.all.to_a

            assert_instance_of Array, plan_products
            assert_equal 1, plan_products.size
            assert_instance_of Pike13::API::V2::Front::PlanProduct, plan_products.first
          end

          def test_find_plan_product
            stub_pike13_request(:get, "/front/plan_products/123", response_body: {
                                  "plan_products" => [{ "id" => 123 }]
                                })

            plan_product = @client.front.plan_products.find(123)

            assert_instance_of Pike13::API::V2::Front::PlanProduct, plan_product
            assert_equal 123, plan_product.id
          end
        end
      end
    end
  end
end
