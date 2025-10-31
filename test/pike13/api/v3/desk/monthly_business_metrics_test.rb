# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V3
      module Desk
        class MonthlyBusinessMetricsTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_basic_query
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/monthly_business_metrics/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["2024-01-01", 50000, 150, 75],
                      ["2024-02-01", 55000, 160, 80]
                    ],
                    "fields" => [
                      { "name" => "month_start_date", "type" => "date" },
                      { "name" => "net_paid_amount", "type" => "currency" },
                      { "name" => "member_count", "type" => "integer" },
                      { "name" => "new_client_count", "type" => "integer" }
                    ],
                    "duration" => 0.125,
                    "has_more" => false,
                    "last_key" => "abc123"
                  }
                }
              }
            )

            result = Pike13::Reporting::MonthlyBusinessMetrics.query(
              fields: ["month_start_date", "net_paid_amount", "member_count", "new_client_count"]
            )

            assert_equal 2, result["data"]["attributes"]["rows"].size
            assert_equal "2024-01-01", result["data"]["attributes"]["rows"].first[0]
            assert_equal 50000, result["data"]["attributes"]["rows"].first[1]
          end

          def test_query_with_filter
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/monthly_business_metrics/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["2024-01-01", 50000],
                      ["2024-02-01", 55000]
                    ],
                    "fields" => [
                      { "name" => "month_start_date", "type" => "date" },
                      { "name" => "net_paid_amount", "type" => "currency" }
                    ],
                    "duration" => 0.125,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::MonthlyBusinessMetrics.query(
              fields: ["month_start_date", "net_paid_amount"],
              filter: ["btw", "month_start_date", "2024-01-01", "2024-12-31"]
            )

            assert_equal 2, result["data"]["attributes"]["rows"].size
          end

          def test_query_with_grouping
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/monthly_business_metrics/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["2024-01-01", 600000, 1200]
                    ],
                    "fields" => [
                      { "name" => "year_start_date", "type" => "date" },
                      { "name" => "total_net_paid_amount", "type" => "currency" },
                      { "name" => "total_new_client_count", "type" => "integer" }
                    ],
                    "duration" => 0.150,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::MonthlyBusinessMetrics.query(
              fields: ["total_net_paid_amount", "total_new_client_count"],
              group: "year_start_date"
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal 600000, result["data"]["attributes"]["rows"].first[1]
          end

          def test_query_with_sorting
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/monthly_business_metrics/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["2024-12-01", 75000],
                      ["2024-11-01", 70000]
                    ],
                    "fields" => [
                      { "name" => "month_start_date", "type" => "date" },
                      { "name" => "net_paid_amount", "type" => "currency" }
                    ],
                    "duration" => 0.100,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::MonthlyBusinessMetrics.query(
              fields: ["month_start_date", "net_paid_amount"],
              sort: ["month_start_date-"]
            )

            assert_equal "2024-12-01", result["data"]["attributes"]["rows"].first[0]
          end

          def test_query_with_pagination
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/monthly_business_metrics/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["2024-01-01", 50000]
                    ],
                    "fields" => [
                      { "name" => "month_start_date", "type" => "date" },
                      { "name" => "net_paid_amount", "type" => "currency" }
                    ],
                    "duration" => 0.080,
                    "has_more" => true,
                    "last_key" => "xyz789"
                  }
                }
              }
            )

            result = Pike13::Reporting::MonthlyBusinessMetrics.query(
              fields: ["month_start_date", "net_paid_amount"],
              page: { limit: 1, starting_after: "abc123" }
            )

            assert result["data"]["attributes"]["has_more"]
            assert_equal "xyz789", result["data"]["attributes"]["last_key"]
          end

          def test_query_with_total_count
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/monthly_business_metrics/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["2024-01-01", 50000]
                    ],
                    "fields" => [
                      { "name" => "month_start_date", "type" => "date" },
                      { "name" => "net_paid_amount", "type" => "currency" }
                    ],
                    "duration" => 0.100,
                    "has_more" => false,
                    "last_key" => nil,
                    "total_count" => 24
                  }
                }
              }
            )

            result = Pike13::Reporting::MonthlyBusinessMetrics.query(
              fields: ["month_start_date", "net_paid_amount"],
              total_count: true
            )

            assert_equal 24, result["data"]["attributes"]["total_count"]
          end

          def test_complex_query
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/monthly_business_metrics/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["2024-06-01", 75000, 200, 90, 850]
                    ],
                    "fields" => [
                      { "name" => "month_start_date", "type" => "date" },
                      { "name" => "net_paid_revenue_amount", "type" => "currency" },
                      { "name" => "member_count", "type" => "integer" },
                      { "name" => "new_client_count", "type" => "integer" },
                      { "name" => "completed_enrollment_count", "type" => "integer" }
                    ],
                    "duration" => 0.175,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::MonthlyBusinessMetrics.query(
              fields: [
                "month_start_date",
                "net_paid_revenue_amount",
                "member_count",
                "new_client_count",
                "completed_enrollment_count"
              ],
              filter: [
                "and",
                [
                  ["btw", "month_start_date", "2024-01-01", "2024-12-31"],
                  ["gt", "net_paid_amount", 0]
                ]
              ],
              sort: ["net_paid_amount-"]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal 5, result["data"]["attributes"]["fields"].size
          end
        end
      end
    end
  end
end
