# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V3
      module Desk
        class InvoiceItemsTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_basic_query
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/invoice_items/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      [12345, "INV-001", "Monthly Membership", 7500, "closed"],
                      [12346, "INV-002", "10 Class Pack", 15000, "open"]
                    ],
                    "fields" => [
                      { "name" => "invoice_item_id", "type" => "integer" },
                      { "name" => "invoice_number", "type" => "string" },
                      { "name" => "product_name", "type" => "string" },
                      { "name" => "expected_amount", "type" => "currency" },
                      { "name" => "invoice_state", "type" => "enum" }
                    ],
                    "duration" => 0.145,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::InvoiceItems.query(
              fields: ["invoice_item_id", "invoice_number", "product_name", "expected_amount", "invoice_state"]
            )

            assert_equal 2, result["data"]["attributes"]["rows"].size
            assert_equal 12345, result["data"]["attributes"]["rows"].first[0]
            assert_equal "Monthly Membership", result["data"]["attributes"]["rows"].first[2]
          end

          def test_query_by_product_type
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/invoice_items/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Annual Membership", "recurring", 90000, 90000, 0]
                    ],
                    "fields" => [
                      { "name" => "product_name", "type" => "string" },
                      { "name" => "product_type", "type" => "enum" },
                      { "name" => "expected_amount", "type" => "currency" },
                      { "name" => "net_paid_amount", "type" => "currency" },
                      { "name" => "outstanding_amount", "type" => "currency" }
                    ],
                    "duration" => 0.135,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::InvoiceItems.query(
              fields: ["product_name", "product_type", "expected_amount", "net_paid_amount", "outstanding_amount"],
              filter: ["eq", "product_type", "recurring"]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal "recurring", result["data"]["attributes"]["rows"].first[1]
          end

          def test_query_outstanding_invoices
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/invoice_items/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["INV-101", "John Doe", "Premium Plan", 12000, 5000]
                    ],
                    "fields" => [
                      { "name" => "invoice_number", "type" => "string" },
                      { "name" => "invoice_payer_name", "type" => "string" },
                      { "name" => "product_name", "type" => "string" },
                      { "name" => "expected_amount", "type" => "currency" },
                      { "name" => "outstanding_amount", "type" => "currency" }
                    ],
                    "duration" => 0.125,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::InvoiceItems.query(
              fields: ["invoice_number", "invoice_payer_name", "product_name", "expected_amount", "outstanding_amount"],
              filter: ["gt", "outstanding_amount", 0],
              sort: ["outstanding_amount-"]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal 5000, result["data"]["attributes"]["rows"].first[4]
          end

          def test_query_with_discounts
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/invoice_items/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Yoga Package", 20000, 2000, 500, 17500]
                    ],
                    "fields" => [
                      { "name" => "product_name", "type" => "string" },
                      { "name" => "gross_amount", "type" => "currency" },
                      { "name" => "discounts_amount", "type" => "currency" },
                      { "name" => "coupons_amount", "type" => "currency" },
                      { "name" => "expected_amount", "type" => "currency" }
                    ],
                    "duration" => 0.155,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::InvoiceItems.query(
              fields: ["product_name", "gross_amount", "discounts_amount", "coupons_amount", "expected_amount"],
              filter: ["gt", "discounts_amount", 0]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal 2000, result["data"]["attributes"]["rows"].first[2]
          end

          def test_query_revenue_tracking
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/invoice_items/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Personal Training", 10000, 9091, 909, 8182]
                    ],
                    "fields" => [
                      { "name" => "product_name", "type" => "string" },
                      { "name" => "gross_amount", "type" => "currency" },
                      { "name" => "expected_revenue_amount", "type" => "currency" },
                      { "name" => "expected_tax_amount", "type" => "currency" },
                      { "name" => "net_paid_revenue_amount", "type" => "currency" }
                    ],
                    "duration" => 0.140,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::InvoiceItems.query(
              fields: ["product_name", "gross_amount", "expected_revenue_amount", "expected_tax_amount", "net_paid_revenue_amount"]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal 9091, result["data"]["attributes"]["rows"].first[2]
          end

          def test_query_by_revenue_category
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/invoice_items/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Memberships", "Monthly Plan", 7500, 7500]
                    ],
                    "fields" => [
                      { "name" => "revenue_category", "type" => "string" },
                      { "name" => "product_name", "type" => "string" },
                      { "name" => "expected_amount", "type" => "currency" },
                      { "name" => "net_paid_amount", "type" => "currency" }
                    ],
                    "duration" => 0.130,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::InvoiceItems.query(
              fields: ["revenue_category", "product_name", "expected_amount", "net_paid_amount"],
              filter: ["not_null", "revenue_category"]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal "Memberships", result["data"]["attributes"]["rows"].first[0]
          end

          def test_query_group_by_product
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/invoice_items/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Monthly Membership", 125, 937500, 875000, 62500],
                      ["10 Class Pack", 85, 1275000, 1200000, 75000]
                    ],
                    "fields" => [
                      { "name" => "product_name", "type" => "string" },
                      { "name" => "invoice_item_count", "type" => "integer" },
                      { "name" => "total_expected_amount", "type" => "currency" },
                      { "name" => "total_net_paid_amount", "type" => "currency" },
                      { "name" => "total_outstanding_amount", "type" => "currency" }
                    ],
                    "duration" => 0.185,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::InvoiceItems.query(
              fields: ["invoice_item_count", "total_expected_amount", "total_net_paid_amount", "total_outstanding_amount"],
              group: "product_name"
            )

            assert_equal 2, result["data"]["attributes"]["rows"].size
            assert_equal 125, result["data"]["attributes"]["rows"].first[1]
          end

          def test_query_group_by_product_type
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/invoice_items/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["recurring", 320, 2400000, 150000, 2250000],
                      ["pass", 180, 2700000, 200000, 2500000]
                    ],
                    "fields" => [
                      { "name" => "product_type", "type" => "enum" },
                      { "name" => "invoice_item_count", "type" => "integer" },
                      { "name" => "total_gross_amount", "type" => "currency" },
                      { "name" => "total_discounts_amount", "type" => "currency" },
                      { "name" => "total_expected_amount", "type" => "currency" }
                    ],
                    "duration" => 0.175,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::InvoiceItems.query(
              fields: ["invoice_item_count", "total_gross_amount", "total_discounts_amount", "total_expected_amount"],
              group: "product_type"
            )

            assert_equal 2, result["data"]["attributes"]["rows"].size
            assert_equal "recurring", result["data"]["attributes"]["rows"].first[0]
          end

          def test_query_monthly_revenue
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/invoice_items/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["2024-10-01", 450, 4500000, 4200000]
                    ],
                    "fields" => [
                      { "name" => "issued_month_start_date", "type" => "date" },
                      { "name" => "invoice_item_count", "type" => "integer" },
                      { "name" => "total_expected_revenue_amount", "type" => "currency" },
                      { "name" => "total_net_paid_revenue_amount", "type" => "currency" }
                    ],
                    "duration" => 0.195,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::InvoiceItems.query(
              fields: ["invoice_item_count", "total_expected_revenue_amount", "total_net_paid_revenue_amount"],
              group: "issued_month_start_date"
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal 450, result["data"]["attributes"]["rows"].first[1]
          end

          def test_query_with_pagination
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/invoice_items/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      [50001, "INV-500", "Starter Pack"]
                    ],
                    "fields" => [
                      { "name" => "invoice_item_id", "type" => "integer" },
                      { "name" => "invoice_number", "type" => "string" },
                      { "name" => "product_name", "type" => "string" }
                    ],
                    "duration" => 0.095,
                    "has_more" => true,
                    "last_key" => "ii_50001"
                  }
                }
              }
            )

            result = Pike13::Reporting::InvoiceItems.query(
              fields: ["invoice_item_id", "invoice_number", "product_name"],
              page: { limit: 1 }
            )

            assert result["data"]["attributes"]["has_more"]
            assert_equal "ii_50001", result["data"]["attributes"]["last_key"]
          end

          def test_complex_query
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/invoice_items/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      [60001, "INV-600", "Jane Smith", "Premium Package", 25000, 2500, 500, 22000, 20000, 2000]
                    ],
                    "fields" => [
                      { "name" => "invoice_item_id", "type" => "integer" },
                      { "name" => "invoice_number", "type" => "string" },
                      { "name" => "invoice_payer_name", "type" => "string" },
                      { "name" => "product_name", "type" => "string" },
                      { "name" => "gross_amount", "type" => "currency" },
                      { "name" => "discounts_amount", "type" => "currency" },
                      { "name" => "coupons_amount", "type" => "currency" },
                      { "name" => "expected_amount", "type" => "currency" },
                      { "name" => "net_paid_amount", "type" => "currency" },
                      { "name" => "outstanding_amount", "type" => "currency" }
                    ],
                    "duration" => 0.210,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::InvoiceItems.query(
              fields: [
                "invoice_item_id",
                "invoice_number",
                "invoice_payer_name",
                "product_name",
                "gross_amount",
                "discounts_amount",
                "coupons_amount",
                "expected_amount",
                "net_paid_amount",
                "outstanding_amount"
              ],
              filter: [
                "and",
                [
                  ["eq", "invoice_state", "open"],
                  ["gt", "expected_amount", 10000]
                ]
              ],
              sort: ["expected_amount-"]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal 10, result["data"]["attributes"]["fields"].size
            assert_equal 25000, result["data"]["attributes"]["rows"].first[4]
          end
        end
      end
    end
  end
end
