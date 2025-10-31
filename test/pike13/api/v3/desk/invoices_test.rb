# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V3
      module Desk
        class InvoicesTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_basic_query
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/invoices/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      [10001, "INV-2024-001", 15000, 0, "closed"],
                      [10002, "INV-2024-002", 25000, 5000, "open"]
                    ],
                    "fields" => [
                      { "name" => "invoice_id", "type" => "integer" },
                      { "name" => "invoice_number", "type" => "string" },
                      { "name" => "expected_amount", "type" => "currency" },
                      { "name" => "outstanding_amount", "type" => "currency" },
                      { "name" => "invoice_state", "type" => "enum" }
                    ],
                    "duration" => 0.155,
                    "has_more" => false,
                    "last_key" => "inv_10002"
                  }
                }
              }
            )

            result = Pike13::Reporting::Invoices.query(
              fields: ["invoice_id", "invoice_number", "expected_amount", "outstanding_amount", "invoice_state"]
            )

            assert_equal 2, result["data"]["attributes"]["rows"].size
            assert_equal 10001, result["data"]["attributes"]["rows"].first[0]
            assert_equal "INV-2024-001", result["data"]["attributes"]["rows"].first[1]
          end

          def test_query_unpaid_invoices
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/invoices/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["INV-2024-005", "John Smith", 12000, "2024-10-15"]
                    ],
                    "fields" => [
                      { "name" => "invoice_number", "type" => "string" },
                      { "name" => "invoice_payer_name", "type" => "string" },
                      { "name" => "outstanding_amount", "type" => "currency" },
                      { "name" => "invoice_due_date", "type" => "date" }
                    ],
                    "duration" => 0.135,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::Invoices.query(
              fields: ["invoice_number", "invoice_payer_name", "outstanding_amount", "invoice_due_date"],
              filter: ["gt", "outstanding_amount", 0],
              sort: ["invoice_due_date"]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal 12000, result["data"]["attributes"]["rows"].first[2]
          end

          def test_query_overdue_invoices
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/invoices/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["INV-2024-010", "Jane Doe", 8500, 15]
                    ],
                    "fields" => [
                      { "name" => "invoice_number", "type" => "string" },
                      { "name" => "invoice_payer_name", "type" => "string" },
                      { "name" => "outstanding_amount", "type" => "currency" },
                      { "name" => "days_since_invoice_due", "type" => "integer" }
                    ],
                    "duration" => 0.145,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::Invoices.query(
              fields: ["invoice_number", "invoice_payer_name", "outstanding_amount", "days_since_invoice_due"],
              filter: [
                "and",
                [
                  ["eq", "invoice_state", "open"],
                  ["gt", "days_since_invoice_due", 0]
                ]
              ]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal 15, result["data"]["attributes"]["rows"].first[3]
          end

          def test_query_by_date_range
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/invoices/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["INV-2024-020", 35000, 35000, "Alice Johnson"]
                    ],
                    "fields" => [
                      { "name" => "invoice_number", "type" => "string" },
                      { "name" => "expected_amount", "type" => "currency" },
                      { "name" => "net_paid_amount", "type" => "currency" },
                      { "name" => "invoice_payer_name", "type" => "string" }
                    ],
                    "duration" => 0.165,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::Invoices.query(
              fields: ["invoice_number", "expected_amount", "net_paid_amount", "invoice_payer_name"],
              filter: ["btw", "issued_date", "2024-01-01", "2024-12-31"]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal 35000, result["data"]["attributes"]["rows"].first[1]
          end

          def test_query_group_by_state
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/invoices/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["open", 45, 675000, 125000],
                      ["closed", 180, 2850000, 0]
                    ],
                    "fields" => [
                      { "name" => "invoice_state", "type" => "enum" },
                      { "name" => "invoice_count", "type" => "integer" },
                      { "name" => "total_expected_amount", "type" => "currency" },
                      { "name" => "total_outstanding_amount", "type" => "currency" }
                    ],
                    "duration" => 0.195,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::Invoices.query(
              fields: ["invoice_count", "total_expected_amount", "total_outstanding_amount"],
              group: "invoice_state"
            )

            assert_equal 2, result["data"]["attributes"]["rows"].size
            assert_equal 45, result["data"]["attributes"]["rows"].first[1]
          end

          def test_query_monthly_summary
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/invoices/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["2024-01-01", 450000, 425000, 25000, 85],
                      ["2024-02-01", 520000, 500000, 20000, 92]
                    ],
                    "fields" => [
                      { "name" => "issued_month_start_date", "type" => "date" },
                      { "name" => "total_expected_amount", "type" => "currency" },
                      { "name" => "total_net_paid_amount", "type" => "currency" },
                      { "name" => "total_outstanding_amount", "type" => "currency" },
                      { "name" => "invoice_count", "type" => "integer" }
                    ],
                    "duration" => 0.210,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::Invoices.query(
              fields: ["total_expected_amount", "total_net_paid_amount", "total_outstanding_amount", "invoice_count"],
              group: "issued_month_start_date",
              sort: ["issued_month_start_date"]
            )

            assert_equal 2, result["data"]["attributes"]["rows"].size
            assert_equal "2024-01-01", result["data"]["attributes"]["rows"].first[0]
          end

          def test_query_with_discounts
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/invoices/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["INV-2024-030", 50000, 5000, 2000, 43000]
                    ],
                    "fields" => [
                      { "name" => "invoice_number", "type" => "string" },
                      { "name" => "gross_amount", "type" => "currency" },
                      { "name" => "discounts_amount", "type" => "currency" },
                      { "name" => "coupons_amount", "type" => "currency" },
                      { "name" => "expected_amount", "type" => "currency" }
                    ],
                    "duration" => 0.125,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::Invoices.query(
              fields: [
                "invoice_number",
                "gross_amount",
                "discounts_amount",
                "coupons_amount",
                "expected_amount"
              ],
              filter: ["gt", "discounts_amount", 0]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal 5000, result["data"]["attributes"]["rows"].first[2]
          end

          def test_query_with_pagination
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/invoices/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      [10050, "INV-2024-050", 18000]
                    ],
                    "fields" => [
                      { "name" => "invoice_id", "type" => "integer" },
                      { "name" => "invoice_number", "type" => "string" },
                      { "name" => "expected_amount", "type" => "currency" }
                    ],
                    "duration" => 0.095,
                    "has_more" => true,
                    "last_key" => "inv_10050"
                  }
                }
              }
            )

            result = Pike13::Reporting::Invoices.query(
              fields: ["invoice_id", "invoice_number", "expected_amount"],
              page: { limit: 1 }
            )

            assert result["data"]["attributes"]["has_more"]
            assert_equal "inv_10050", result["data"]["attributes"]["last_key"]
          end

          def test_complex_query
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/invoices/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      [10075, "INV-2024-075", "open", 45000, 42000, 3000, "Bob Williams", "2024-11-01"]
                    ],
                    "fields" => [
                      { "name" => "invoice_id", "type" => "integer" },
                      { "name" => "invoice_number", "type" => "string" },
                      { "name" => "invoice_state", "type" => "enum" },
                      { "name" => "expected_amount", "type" => "currency" },
                      { "name" => "net_paid_amount", "type" => "currency" },
                      { "name" => "outstanding_amount", "type" => "currency" },
                      { "name" => "invoice_payer_name", "type" => "string" },
                      { "name" => "invoice_due_date", "type" => "date" }
                    ],
                    "duration" => 0.185,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::Invoices.query(
              fields: [
                "invoice_id",
                "invoice_number",
                "invoice_state",
                "expected_amount",
                "net_paid_amount",
                "outstanding_amount",
                "invoice_payer_name",
                "invoice_due_date"
              ],
              filter: [
                "and",
                [
                  ["btw", "issued_date", "2024-01-01", "2024-12-31"],
                  ["eq", "invoice_state", "open"],
                  ["gt", "expected_amount", 20000]
                ]
              ],
              sort: ["expected_amount-"]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal 8, result["data"]["attributes"]["fields"].size
          end
        end
      end
    end
  end
end
