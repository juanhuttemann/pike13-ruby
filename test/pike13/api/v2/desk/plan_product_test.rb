# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class PlanProductTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_all_plan_products
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/plan_products", response_body: {
                                  "plan_products" => [{ "id" => 1 }]
                                })

            plan_products = Pike13::API::V2::Desk::PlanProduct.all

            assert_instance_of Hash, plan_products
            assert_equal 1, plan_products["plan_products"].size
            assert_instance_of Hash, plan_products["plan_products"].first
          end

          def test_find_plan_product
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/plan_products/123", response_body: {
                                  "plan_products" => [{ "id" => 123 }]
                                })

            plan_product = Pike13::API::V2::Desk::PlanProduct.find(123)

            assert_instance_of Hash, plan_product
            assert_equal 123, plan_product["plan_products"].first["id"]
          end
        end
      end
    end
  end
end
