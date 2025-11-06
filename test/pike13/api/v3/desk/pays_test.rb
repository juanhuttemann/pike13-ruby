# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V3
      module Desk
        class PaysTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_basic_query
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/pays/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      [12_345, "Sarah Johnson", "service", 7500, "approved"],
                      [12_346, "Mike Thompson", "commission", 5000, "pending"]
                    ],
                    "fields" => [
                      { "name" => "pay_id", "type" => "integer" },
                      { "name" => "staff_name", "type" => "string" },
                      { "name" => "pay_type", "type" => "enum" },
                      { "name" => "final_pay_amount", "type" => "currency" },
                      { "name" => "pay_state", "type" => "enum" }
                    ],
                    "duration" => 0.145,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::Pays.query(
              fields: %w[pay_id staff_name pay_type final_pay_amount pay_state]
            )

            assert_equal 2, result["data"]["attributes"]["rows"].size
            assert_equal 12_345, result["data"]["attributes"]["rows"].first[0]
            assert_equal "Sarah Johnson", result["data"]["attributes"]["rows"].first[1]
          end

          def test_query_by_staff_member
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/pays/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Sarah Johnson", "Yoga Flow", "2024-10-20", 7500, 1.5]
                    ],
                    "fields" => [
                      { "name" => "staff_name", "type" => "string" },
                      { "name" => "service_name", "type" => "string" },
                      { "name" => "service_date", "type" => "date" },
                      { "name" => "final_pay_amount", "type" => "currency" },
                      { "name" => "service_hours", "type" => "float" }
                    ],
                    "duration" => 0.135,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::Pays.query(
              fields: %w[staff_name service_name service_date final_pay_amount service_hours],
              filter: ["eq", "staff_id", 12_345],
              sort: ["service_date-"]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_in_delta(1.5, result["data"]["attributes"]["rows"].first[4])
          end

          def test_query_pending_approvals
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/pays/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Bob Wilson", "Spin Class - Morning", 5000, "2024-10-18T09:00:00Z"]
                    ],
                    "fields" => [
                      { "name" => "staff_name", "type" => "string" },
                      { "name" => "pay_description", "type" => "string" },
                      { "name" => "final_pay_amount", "type" => "currency" },
                      { "name" => "pay_recorded_at", "type" => "datetime" }
                    ],
                    "duration" => 0.125,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::Pays.query(
              fields: %w[staff_name pay_description final_pay_amount pay_recorded_at],
              filter: %w[eq pay_state pending]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_includes result["data"]["attributes"]["rows"].first[1], "Spin Class"
          end

          def test_query_pay_by_service_type
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/pays/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["CrossFit WOD", "group_class", "Alice Brown", 5000, 1000, 500, 6500]
                    ],
                    "fields" => [
                      { "name" => "service_name", "type" => "string" },
                      { "name" => "service_type", "type" => "enum" },
                      { "name" => "staff_name", "type" => "string" },
                      { "name" => "base_pay_amount", "type" => "currency" },
                      { "name" => "per_head_pay_amount", "type" => "currency" },
                      { "name" => "tiered_pay_amount", "type" => "currency" },
                      { "name" => "final_pay_amount", "type" => "currency" }
                    ],
                    "duration" => 0.155,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::Pays.query(
              fields: %w[service_name service_type staff_name base_pay_amount per_head_pay_amount
                         tiered_pay_amount final_pay_amount]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal 6500, result["data"]["attributes"]["rows"].first[6]
          end

          def test_query_by_pay_period
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/pays/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Carol Davis", "2024-10-15", 7500, "2024-10-01", "2024-10-31"]
                    ],
                    "fields" => [
                      { "name" => "staff_name", "type" => "string" },
                      { "name" => "service_date", "type" => "date" },
                      { "name" => "final_pay_amount", "type" => "currency" },
                      { "name" => "pay_period_start_date", "type" => "date" },
                      { "name" => "pay_period_end_date", "type" => "date" }
                    ],
                    "duration" => 0.140,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::Pays.query(
              fields: %w[staff_name service_date final_pay_amount pay_period_start_date
                         pay_period_end_date],
              filter: ["eq", "pay_period", "2024-10-01..2024-10-31"]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal "2024-10-01", result["data"]["attributes"]["rows"].first[3]
          end

          def test_query_by_pay_type
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/pays/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["service", "Yoga Flow - Morning", 5000, "David Lee"],
                      ["commission", "Product Sales Commission", 2500, "Emily Brown"]
                    ],
                    "fields" => [
                      { "name" => "pay_type", "type" => "enum" },
                      { "name" => "pay_description", "type" => "string" },
                      { "name" => "final_pay_amount", "type" => "currency" },
                      { "name" => "staff_name", "type" => "string" }
                    ],
                    "duration" => 0.130,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::Pays.query(
              fields: %w[pay_type pay_description final_pay_amount staff_name],
              filter: ["in", "pay_type", %w[service commission tip]]
            )

            assert_equal 2, result["data"]["attributes"]["rows"].size
            assert_equal "service", result["data"]["attributes"]["rows"].first[0]
          end

          def test_query_group_by_staff_member
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/pays/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Sarah Johnson", 45, 337_500, 67.5, 300_000],
                      ["Mike Thompson", 38, 285_000, 57.0, 250_000]
                    ],
                    "fields" => [
                      { "name" => "staff_name", "type" => "string" },
                      { "name" => "pay_count", "type" => "integer" },
                      { "name" => "total_final_pay_amount", "type" => "currency" },
                      { "name" => "total_service_hours", "type" => "float" },
                      { "name" => "total_base_pay_amount", "type" => "currency" }
                    ],
                    "duration" => 0.185,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::Pays.query(
              fields: %w[pay_count total_final_pay_amount total_service_hours total_base_pay_amount],
              group: "staff_name"
            )

            assert_equal 2, result["data"]["attributes"]["rows"].size
            assert_equal 45, result["data"]["attributes"]["rows"].first[1]
          end

          def test_query_group_by_service
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/pays/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Yoga Flow", 30, 85, 637_500],
                      ["Spin Class", 25, 72, 540_000]
                    ],
                    "fields" => [
                      { "name" => "service_name", "type" => "string" },
                      { "name" => "service_count", "type" => "integer" },
                      { "name" => "pay_count", "type" => "integer" },
                      { "name" => "total_final_pay_amount", "type" => "currency" }
                    ],
                    "duration" => 0.175,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::Pays.query(
              fields: %w[service_count pay_count total_final_pay_amount],
              group: "service_name"
            )

            assert_equal 2, result["data"]["attributes"]["rows"].size
            assert_equal 30, result["data"]["attributes"]["rows"].first[1]
          end

          def test_query_group_by_pay_type
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/pays/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["service", 320, 2_400_000, 2_000_000, 250_000, 150_000],
                      ["commission", 85, 425_000, 0, 0, 0]
                    ],
                    "fields" => [
                      { "name" => "pay_type", "type" => "enum" },
                      { "name" => "pay_count", "type" => "integer" },
                      { "name" => "total_final_pay_amount", "type" => "currency" },
                      { "name" => "total_base_pay_amount", "type" => "currency" },
                      { "name" => "total_per_head_pay_amount", "type" => "currency" },
                      { "name" => "total_tiered_pay_amount", "type" => "currency" }
                    ],
                    "duration" => 0.195,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::Pays.query(
              fields: %w[pay_count total_final_pay_amount total_base_pay_amount total_per_head_pay_amount
                         total_tiered_pay_amount],
              group: "pay_type"
            )

            assert_equal 2, result["data"]["attributes"]["rows"].size
            assert_equal "service", result["data"]["attributes"]["rows"].first[0]
          end

          def test_query_with_pagination
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/pays/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      [60_001, "Frank Miller", "service"]
                    ],
                    "fields" => [
                      { "name" => "pay_id", "type" => "integer" },
                      { "name" => "staff_name", "type" => "string" },
                      { "name" => "pay_type", "type" => "enum" }
                    ],
                    "duration" => 0.095,
                    "has_more" => true,
                    "last_key" => "pay_60001"
                  }
                }
              }
            )

            result = Pike13::Reporting::Pays.query(
              fields: %w[pay_id staff_name pay_type],
              page: { limit: 1 }
            )

            assert result["data"]["attributes"]["has_more"]
            assert_equal "pay_60001", result["data"]["attributes"]["last_key"]
          end

          def test_complex_query
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/pays/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      [70_001, "Grace Taylor", "service", "Advanced CrossFit", "2024-10-28", 10_000, 8000, 1500, 500]
                    ],
                    "fields" => [
                      { "name" => "pay_id", "type" => "integer" },
                      { "name" => "staff_name", "type" => "string" },
                      { "name" => "pay_type", "type" => "enum" },
                      { "name" => "service_name", "type" => "string" },
                      { "name" => "service_date", "type" => "date" },
                      { "name" => "final_pay_amount", "type" => "currency" },
                      { "name" => "base_pay_amount", "type" => "currency" },
                      { "name" => "per_head_pay_amount", "type" => "currency" },
                      { "name" => "tiered_pay_amount", "type" => "currency" }
                    ],
                    "duration" => 0.210,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::Pays.query(
              fields: %w[
                pay_id
                staff_name
                pay_type
                service_name
                service_date
                final_pay_amount
                base_pay_amount
                per_head_pay_amount
                tiered_pay_amount
              ],
              filter: [
                "and",
                [
                  %w[eq pay_type service],
                  %w[eq pay_state approved],
                  ["gt", "final_pay_amount", 5000]
                ]
              ],
              sort: ["final_pay_amount-"]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal 9, result["data"]["attributes"]["fields"].size
            assert_equal 10_000, result["data"]["attributes"]["rows"].first[5]
          end
        end
      end
    end
  end
end
