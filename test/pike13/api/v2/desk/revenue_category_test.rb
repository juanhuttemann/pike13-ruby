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
            stub_pike13_request(:get, "/desk/revenue_categories", scope: "desk", response_body: {
                                  "revenue_categories" => [{ "id" => 1 }]
                                })

            items = @client.desk.revenue_categories.all

            assert_equal 1, items.size
          end

          def test_find_revenue_category
            stub_pike13_request(:get, "/desk/revenue_categories/123", scope: "desk", response_body: {
                                  "revenue_categories" => [{ "id" => 123 }]
                                })

            item = @client.desk.revenue_categories.find(123)

            assert_equal 123, item.id
          end
        end
      end
    end
  end
end
