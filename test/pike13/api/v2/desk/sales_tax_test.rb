# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class SalesTaxTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_all_sales_taxes
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/sales_taxes", response_body: {
                                  "sales_taxes" => [{ "id" => 1 }]
                                })

            sales_taxes = Pike13::API::V2::Desk::SalesTax.all.to_a

            assert_instance_of Array, sales_taxes
            assert_equal 1, sales_taxes.size
            assert_instance_of Pike13::API::V2::Desk::SalesTax, sales_taxes.first
          end

          def test_find_sales_tax
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/sales_taxes/123", response_body: {
                                  "sales_taxes" => [{ "id" => 123 }]
                                })

            sales_tax = Pike13::API::V2::Desk::SalesTax.find(123)

            assert_instance_of Pike13::API::V2::Desk::SalesTax, sales_tax
            assert_equal 123, sales_tax.id
          end
        end
      end
    end
  end
end
