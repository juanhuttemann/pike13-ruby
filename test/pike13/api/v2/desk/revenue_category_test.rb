# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class RevenueCategoryTest < Minitest::Test
          def setup
            @client = default_client
          end

          def test_all_revenue_categories
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/revenue_categories", response_body: {
                                  "revenue_categories" => [{ "id" => 1 }]
                                })

            revenue_categories = @client.desk.revenue_categories.all.to_a

            assert_instance_of Array, revenue_categories
            assert_equal 1, revenue_categories.size
            assert_instance_of Pike13::API::V2::Desk::RevenueCategory, revenue_categories.first
          end

          def test_find_revenue_category
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/revenue_categories/123", response_body: {
                                  "revenue_categories" => [{ "id" => 123 }]
                                })

            revenue_category = @client.desk.revenue_categories.find(123)

            assert_instance_of Pike13::API::V2::Desk::RevenueCategory, revenue_category
            assert_equal 123, revenue_category.id
          end
        end
      end
    end
  end
end
