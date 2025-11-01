# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V3
      module Desk
        class InvoiceItemTransactionsTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_basic_query
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/invoice_item_transactions/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      [54321, "INV-001", "payment", 7500, "settled"],
                      [54322, "INV-002", "refund", -2500, "settled"]
                    ],
                    "fields" => [
                      { "name" => "transaction_id", "type" => "integer" },
                      { "name" => "invoice_number", "type" => "string" },
                      { "name" => "transaction_type", "type" => "enum" },
                      { "name" => "transaction_amount", "type" => "currency" },
                      { "name" => "transaction_state", "type" => "enum" }
                    ],
                    "duration" => 0.145,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::InvoiceItemTransactions.query(
              fields: ["transaction_id", "invoice_number", "transaction_type", "transaction_amount", "transaction_state"]
            )

            assert_equal 2, result["data"]["attributes"]["rows"].size
            assert_equal 54321, result["data"]["attributes"]["rows"].first[0]
            assert_equal "payment", result["data"]["attributes"]["rows"].first[2]
          end

          def test_query_by_payment_method
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/invoice_item_transactions/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["2024-10-20", "creditcard", 15000, "Jane Smith", "Monthly Membership"]
                    ],
                    "fields" => [
                      { "name" => "transaction_date", "type" => "date" },
                      { "name" => "payment_method", "type" => "enum" },
                      { "name" => "transaction_amount", "type" => "currency" },
                      { "name" => "invoice_payer_name", "type" => "string" },
                      { "name" => "product_name", "type" => "string" }
                    ],
                    "duration" => 0.135,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::InvoiceItemTransactions.query(
              fields: ["transaction_date", "payment_method", "transaction_amount", "invoice_payer_name", "product_name"],
              filter: ["eq", "payment_method", "creditcard"]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal "creditcard", result["data"]["attributes"]["rows"].first[1]
          end

          def test_query_successful_payments
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/invoice_item_transactions/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["2024-10-18", "INV-101", "creditcard", 10000, "Visa **** 1234 exp 12/25"]
                    ],
                    "fields" => [
                      { "name" => "transaction_date", "type" => "date" },
                      { "name" => "invoice_number", "type" => "string" },
                      { "name" => "payment_method", "type" => "enum" },
                      { "name" => "net_paid_amount", "type" => "currency" },
                      { "name" => "payment_method_detail", "type" => "string" }
                    ],
                    "duration" => 0.125,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::InvoiceItemTransactions.query(
              fields: ["transaction_date", "invoice_number", "payment_method", "net_paid_amount", "payment_method_detail"],
              filter: [
                "and",
                [
                  ["eq", "transaction_type", "payment"],
                  ["eq", "transaction_state", "settled"]
                ]
              ]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert result["data"]["attributes"]["rows"].first[4].include?("Visa")
          end

          def test_query_failed_transactions
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/invoice_item_transactions/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["2024-10-15", "Bob Wilson", "creditcard", 5000, "Card declined - insufficient funds"]
                    ],
                    "fields" => [
                      { "name" => "failed_date", "type" => "date" },
                      { "name" => "invoice_payer_name", "type" => "string" },
                      { "name" => "payment_method", "type" => "enum" },
                      { "name" => "transaction_amount", "type" => "currency" },
                      { "name" => "error_message", "type" => "string" }
                    ],
                    "duration" => 0.155,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::InvoiceItemTransactions.query(
              fields: ["failed_date", "invoice_payer_name", "payment_method", "transaction_amount", "error_message"],
              filter: ["eq", "transaction_state", "failed"],
              sort: ["failed_date-"]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert result["data"]["attributes"]["rows"].first[4].include?("declined")
          end

          def test_query_refunds
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/invoice_item_transactions/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["2024-10-22", "INV-200", -3000, "Alice Johnson", 54123]
                    ],
                    "fields" => [
                      { "name" => "transaction_date", "type" => "date" },
                      { "name" => "invoice_number", "type" => "string" },
                      { "name" => "refunds_amount", "type" => "currency" },
                      { "name" => "invoice_payer_name", "type" => "string" },
                      { "name" => "payment_transaction_id", "type" => "integer" }
                    ],
                    "duration" => 0.140,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::InvoiceItemTransactions.query(
              fields: ["transaction_date", "invoice_number", "refunds_amount", "invoice_payer_name", "payment_transaction_id"],
              filter: ["eq", "transaction_type", "refund"]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal(-3000, result["data"]["attributes"]["rows"].first[2])
          end

          def test_query_revenue_by_product
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/invoice_item_transactions/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Premium Package", 20000, 18182, 1818, "creditcard"]
                    ],
                    "fields" => [
                      { "name" => "product_name", "type" => "string" },
                      { "name" => "transaction_amount", "type" => "currency" },
                      { "name" => "net_paid_revenue_amount", "type" => "currency" },
                      { "name" => "net_paid_tax_amount", "type" => "currency" },
                      { "name" => "payment_method", "type" => "enum" }
                    ],
                    "duration" => 0.130,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::InvoiceItemTransactions.query(
              fields: ["product_name", "transaction_amount", "net_paid_revenue_amount", "net_paid_tax_amount", "payment_method"]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal 18182, result["data"]["attributes"]["rows"].first[2]
          end

          def test_query_group_by_payment_method
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/invoice_item_transactions/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["creditcard", 450, 3375000, 442, 8],
                      ["cash", 125, 562500, 125, 0]
                    ],
                    "fields" => [
                      { "name" => "payment_method", "type" => "enum" },
                      { "name" => "transaction_count", "type" => "integer" },
                      { "name" => "total_net_paid_amount", "type" => "currency" },
                      { "name" => "settled_count", "type" => "integer" },
                      { "name" => "failed_count", "type" => "integer" }
                    ],
                    "duration" => 0.185,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::InvoiceItemTransactions.query(
              fields: ["transaction_count", "total_net_paid_amount", "settled_count", "failed_count"],
              group: "payment_method"
            )

            assert_equal 2, result["data"]["attributes"]["rows"].size
            assert_equal 450, result["data"]["attributes"]["rows"].first[1]
          end

          def test_query_group_by_credit_card_type
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/invoice_item_transactions/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["visa", 280, 2100000, 1575000, 315000, 210000],
                      ["mastercard", 120, 900000, 675000, 135000, 90000]
                    ],
                    "fields" => [
                      { "name" => "credit_card_name", "type" => "enum" },
                      { "name" => "transaction_count", "type" => "integer" },
                      { "name" => "total_net_visa_paid_amount", "type" => "currency" },
                      { "name" => "total_net_mastercard_paid_amount", "type" => "currency" },
                      { "name" => "total_net_american_express_paid_amount", "type" => "currency" },
                      { "name" => "total_net_discover_paid_amount", "type" => "currency" }
                    ],
                    "duration" => 0.175,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::InvoiceItemTransactions.query(
              fields: ["transaction_count", "total_net_visa_paid_amount", "total_net_mastercard_paid_amount", "total_net_american_express_paid_amount", "total_net_discover_paid_amount"],
              group: "credit_card_name"
            )

            assert_equal 2, result["data"]["attributes"]["rows"].size
            assert_equal "visa", result["data"]["attributes"]["rows"].first[0]
          end

          def test_query_monthly_summary
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/invoice_item_transactions/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["2024-10-01", 575, 5250000, 125000, 4725000]
                    ],
                    "fields" => [
                      { "name" => "transaction_month_start_date", "type" => "date" },
                      { "name" => "transaction_count", "type" => "integer" },
                      { "name" => "total_payments_amount", "type" => "currency" },
                      { "name" => "total_refunds_amount", "type" => "currency" },
                      { "name" => "total_net_paid_revenue_amount", "type" => "currency" }
                    ],
                    "duration" => 0.195,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::InvoiceItemTransactions.query(
              fields: ["transaction_count", "total_payments_amount", "total_refunds_amount", "total_net_paid_revenue_amount"],
              group: "transaction_month_start_date"
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal 575, result["data"]["attributes"]["rows"].first[1]
          end

          def test_query_with_pagination
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/invoice_item_transactions/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      [60001, "INV-500", "payment"]
                    ],
                    "fields" => [
                      { "name" => "transaction_id", "type" => "integer" },
                      { "name" => "invoice_number", "type" => "string" },
                      { "name" => "transaction_type", "type" => "enum" }
                    ],
                    "duration" => 0.095,
                    "has_more" => true,
                    "last_key" => "iit_60001"
                  }
                }
              }
            )

            result = Pike13::Reporting::InvoiceItemTransactions.query(
              fields: ["transaction_id", "invoice_number", "transaction_type"],
              page: { limit: 1 }
            )

            assert result["data"]["attributes"]["has_more"]
            assert_equal "iit_60001", result["data"]["attributes"]["last_key"]
          end

          def test_complex_query
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/invoice_item_transactions/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      [70001, "INV-600", "Sarah Brown", "payment", "creditcard", "settled", 25000, 22727, 2273]
                    ],
                    "fields" => [
                      { "name" => "transaction_id", "type" => "integer" },
                      { "name" => "invoice_number", "type" => "string" },
                      { "name" => "invoice_payer_name", "type" => "string" },
                      { "name" => "transaction_type", "type" => "enum" },
                      { "name" => "payment_method", "type" => "enum" },
                      { "name" => "transaction_state", "type" => "enum" },
                      { "name" => "transaction_amount", "type" => "currency" },
                      { "name" => "net_paid_revenue_amount", "type" => "currency" },
                      { "name" => "net_paid_tax_amount", "type" => "currency" }
                    ],
                    "duration" => 0.210,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::InvoiceItemTransactions.query(
              fields: [
                "transaction_id",
                "invoice_number",
                "invoice_payer_name",
                "transaction_type",
                "payment_method",
                "transaction_state",
                "transaction_amount",
                "net_paid_revenue_amount",
                "net_paid_tax_amount"
              ],
              filter: [
                "and",
                [
                  ["eq", "transaction_type", "payment"],
                  ["eq", "transaction_state", "settled"],
                  ["gt", "transaction_amount", 10000]
                ]
              ],
              sort: ["transaction_amount-"]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal 9, result["data"]["attributes"]["fields"].size
            assert_equal 25000, result["data"]["attributes"]["rows"].first[6]
          end
        end
      end
    end
  end
end
