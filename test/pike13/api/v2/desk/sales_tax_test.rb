# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class SalesTaxTest < Minitest::Test
          def setup
            @client = default_client
          end

          def test_all_sales_taxes
            stub_pike13_request(:get, "/desk/sales_taxes", response_body: {
                                  "sales_taxes" => [{ "id" => 1 }]
                                })

            items = @client.desk.sales_taxes.all

            assert_equal 1, items.size
          end

          def test_find_sales_tax
            stub_pike13_request(:get, "/desk/sales_taxes/123", response_body: {
                                  "sales_taxes" => [{ "id" => 123 }]
                                })

            item = @client.desk.sales_taxes.find(123)

            assert_equal 123, item.id
          end
        end
      end
    end
  end
end
