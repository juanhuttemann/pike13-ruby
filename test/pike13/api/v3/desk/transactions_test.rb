# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V3
      module Desk
        class TransactionsTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_basic_query
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/transactions/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      [12345, "2024-10-15", 15000, "creditcard", "John Smith"],
                      [12346, "2024-10-16", 8500, "cash", "Jane Doe"]
                    ],
                    "fields" => [
                      { "name" => "transaction_id", "type" => "integer" },
                      { "name" => "transaction_date", "type" => "date" },
                      { "name" => "net_paid_amount", "type" => "currency" },
                      { "name" => "payment_method", "type" => "enum" },
                      { "name" => "invoice_payer_name", "type" => "string" }
                    ],
                    "duration" => 0.145,
                    "has_more" => false,
                    "last_key" => "txn_12346"
                  }
                }
              }
            )

            result = Pike13::Reporting::Transactions.query(
              fields: ["transaction_id", "transaction_date", "net_paid_amount", "payment_method", "invoice_payer_name"]
            )

            assert_equal 2, result["data"]["attributes"]["rows"].size
            assert_equal 12345, result["data"]["attributes"]["rows"].first[0]
            assert_equal 15000, result["data"]["attributes"]["rows"].first[2]
          end

          def test_query_with_date_filter
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/transactions/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["2024-06-15", 25000, "Alice Johnson", "creditcard"]
                    ],
                    "fields" => [
                      { "name" => "transaction_date", "type" => "date" },
                      { "name" => "net_paid_amount", "type" => "currency" },
                      { "name" => "invoice_payer_name", "type" => "string" },
                      { "name" => "payment_method", "type" => "enum" }
                    ],
                    "duration" => 0.160,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::Transactions.query(
              fields: ["transaction_date", "net_paid_amount", "invoice_payer_name", "payment_method"],
              filter: ["btw", "transaction_date", "2024-01-01", "2024-12-31"],
              sort: ["transaction_date-"]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal "2024-06-15", result["data"]["attributes"]["rows"].first[0]
          end

          def test_query_with_payment_method_filter
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/transactions/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["2024-10-20", 12000, "Bob Williams"]
                    ],
                    "fields" => [
                      { "name" => "transaction_date", "type" => "date" },
                      { "name" => "net_paid_amount", "type" => "currency" },
                      { "name" => "invoice_payer_name", "type" => "string" }
                    ],
                    "duration" => 0.125,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::Transactions.query(
              fields: ["transaction_date", "net_paid_amount", "invoice_payer_name"],
              filter: ["eq", "payment_method", "creditcard"]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
          end

          def test_query_failed_transactions
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/transactions/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["2024-10-18", 5000, "Insufficient funds", "Carol Davis"]
                    ],
                    "fields" => [
                      { "name" => "transaction_date", "type" => "date" },
                      { "name" => "transaction_amount", "type" => "currency" },
                      { "name" => "error_message", "type" => "string" },
                      { "name" => "invoice_payer_name", "type" => "string" }
                    ],
                    "duration" => 0.135,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::Transactions.query(
              fields: ["transaction_date", "transaction_amount", "error_message", "invoice_payer_name"],
              filter: ["eq", "transaction_state", "failed"]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal "Insufficient funds", result["data"]["attributes"]["rows"].first[2]
          end

          def test_query_group_by_payment_method
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/transactions/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["creditcard", 450000, 425000, 85],
                      ["cash", 125000, 125000, 32],
                      ["check", 35000, 35000, 8]
                    ],
                    "fields" => [
                      { "name" => "payment_method", "type" => "enum" },
                      { "name" => "total_net_paid_amount", "type" => "currency" },
                      { "name" => "total_payments_amount", "type" => "currency" },
                      { "name" => "transaction_count", "type" => "integer" }
                    ],
                    "duration" => 0.195,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::Transactions.query(
              fields: ["total_net_paid_amount", "total_payments_amount", "transaction_count"],
              group: "payment_method"
            )

            assert_equal 3, result["data"]["attributes"]["rows"].size
            assert_equal 450000, result["data"]["attributes"]["rows"].first[1]
          end

          def test_query_group_by_month
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/transactions/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["2024-01-01", 250000, 235000, 125],
                      ["2024-02-01", 275000, 260000, 138]
                    ],
                    "fields" => [
                      { "name" => "transaction_month_start_date", "type" => "date" },
                      { "name" => "total_net_paid_amount", "type" => "currency" },
                      { "name" => "total_net_paid_revenue_amount", "type" => "currency" },
                      { "name" => "transaction_count", "type" => "integer" }
                    ],
                    "duration" => 0.210,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::Transactions.query(
              fields: ["total_net_paid_amount", "total_net_paid_revenue_amount", "transaction_count"],
              group: "transaction_month_start_date",
              sort: ["transaction_month_start_date"]
            )

            assert_equal 2, result["data"]["attributes"]["rows"].size
            assert_equal "2024-01-01", result["data"]["attributes"]["rows"].first[0]
          end

          def test_query_card_type_breakdown
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/transactions/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["2024-10-01", 125000, 85000, 45000, 15000]
                    ],
                    "fields" => [
                      { "name" => "transaction_month_start_date", "type" => "date" },
                      { "name" => "total_net_visa_paid_amount", "type" => "currency" },
                      { "name" => "total_net_mastercard_paid_amount", "type" => "currency" },
                      { "name" => "total_net_american_express_paid_amount", "type" => "currency" },
                      { "name" => "total_net_discover_paid_amount", "type" => "currency" }
                    ],
                    "duration" => 0.185,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::Transactions.query(
              fields: [
                "total_net_visa_paid_amount",
                "total_net_mastercard_paid_amount",
                "total_net_american_express_paid_amount",
                "total_net_discover_paid_amount"
              ],
              group: "transaction_month_start_date"
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal 125000, result["data"]["attributes"]["rows"].first[1]
          end

          def test_query_with_pagination
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/transactions/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      [12347, "2024-10-17", 9500]
                    ],
                    "fields" => [
                      { "name" => "transaction_id", "type" => "integer" },
                      { "name" => "transaction_date", "type" => "date" },
                      { "name" => "net_paid_amount", "type" => "currency" }
                    ],
                    "duration" => 0.095,
                    "has_more" => true,
                    "last_key" => "txn_12347"
                  }
                }
              }
            )

            result = Pike13::Reporting::Transactions.query(
              fields: ["transaction_id", "transaction_date", "net_paid_amount"],
              page: { limit: 1 }
            )

            assert result["data"]["attributes"]["has_more"]
            assert_equal "txn_12347", result["data"]["attributes"]["last_key"]
          end

          def test_complex_query
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/transactions/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      [12348, "2024-10-19", 35000, "creditcard", "settled", "David Lee", "Downtown"]
                    ],
                    "fields" => [
                      { "name" => "transaction_id", "type" => "integer" },
                      { "name" => "transaction_date", "type" => "date" },
                      { "name" => "net_paid_amount", "type" => "currency" },
                      { "name" => "payment_method", "type" => "enum" },
                      { "name" => "transaction_state", "type" => "enum" },
                      { "name" => "invoice_payer_name", "type" => "string" },
                      { "name" => "sale_location_name", "type" => "string" }
                    ],
                    "duration" => 0.175,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::Transactions.query(
              fields: [
                "transaction_id",
                "transaction_date",
                "net_paid_amount",
                "payment_method",
                "transaction_state",
                "invoice_payer_name",
                "sale_location_name"
              ],
              filter: [
                "and",
                [
                  ["btw", "transaction_date", "2024-01-01", "2024-12-31"],
                  ["eq", "transaction_state", "settled"],
                  ["gt", "net_paid_amount", 10000]
                ]
              ],
              sort: ["net_paid_amount-"]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal 7, result["data"]["attributes"]["fields"].size
          end
        end
      end
    end
  end
end
