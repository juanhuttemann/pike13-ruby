# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V3
      module Desk
        class EnrollmentsTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_basic_query
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/enrollments/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      [10001, "John Smith", "Yoga Class", "completed", "2024-10-15"],
                      [10002, "Jane Doe", "Pilates", "registered", "2024-10-16"]
                    ],
                    "fields" => [
                      { "name" => "visit_id", "type" => "integer" },
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "service_name", "type" => "string" },
                      { "name" => "state", "type" => "enum" },
                      { "name" => "service_date", "type" => "date" }
                    ],
                    "duration" => 0.165,
                    "has_more" => false,
                    "last_key" => "enr_10002"
                  }
                }
              }
            )

            result = Pike13::Reporting::Enrollments.query(
              fields: ["visit_id", "full_name", "service_name", "state", "service_date"]
            )

            assert_equal 2, result["data"]["attributes"]["rows"].size
            assert_equal 10001, result["data"]["attributes"]["rows"].first[0]
            assert_equal "John Smith", result["data"]["attributes"]["rows"].first[1]
          end

          def test_query_completed_visits
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/enrollments/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Alice Johnson", "CrossFit", "2024-10-20", 2500, "Coach Mike"]
                    ],
                    "fields" => [
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "service_name", "type" => "string" },
                      { "name" => "service_date", "type" => "date" },
                      { "name" => "estimated_amount", "type" => "currency" },
                      { "name" => "instructor_names", "type" => "string" }
                    ],
                    "duration" => 0.145,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::Enrollments.query(
              fields: ["full_name", "service_name", "service_date", "estimated_amount", "instructor_names"],
              filter: ["eq", "state", "completed"],
              sort: ["service_date-"]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal 2500, result["data"]["attributes"]["rows"].first[3]
          end

          def test_query_by_date_range
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/enrollments/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Bob Williams", "Spin Class", "2024-06-15", "completed"]
                    ],
                    "fields" => [
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "service_name", "type" => "string" },
                      { "name" => "service_date", "type" => "date" },
                      { "name" => "state", "type" => "enum" }
                    ],
                    "duration" => 0.155,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::Enrollments.query(
              fields: ["full_name", "service_name", "service_date", "state"],
              filter: ["btw", "service_date", "2024-01-01", "2024-12-31"]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal "2024-06-15", result["data"]["attributes"]["rows"].first[2]
          end

          def test_query_first_time_visitors
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/enrollments/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Carol Davis", "carol@example.com", "Boxing", "2024-10-18"]
                    ],
                    "fields" => [
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "email", "type" => "string" },
                      { "name" => "service_name", "type" => "string" },
                      { "name" => "service_date", "type" => "date" }
                    ],
                    "duration" => 0.135,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::Enrollments.query(
              fields: ["full_name", "email", "service_name", "service_date"],
              filter: ["eq", "first_visit", true]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert result["data"]["attributes"]["rows"].first[1].include?("@")
          end

          def test_query_unpaid_visits
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/enrollments/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["David Lee", "Martial Arts", "2024-10-19", "Monthly Membership, Drop-in Pass"]
                    ],
                    "fields" => [
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "service_name", "type" => "string" },
                      { "name" => "service_date", "type" => "date" },
                      { "name" => "available_plans", "type" => "string" }
                    ],
                    "duration" => 0.140,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::Enrollments.query(
              fields: ["full_name", "service_name", "service_date", "available_plans"],
              filter: ["eq", "is_paid", false]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert result["data"]["attributes"]["rows"].first[3].include?("Pass")
          end

          def test_query_group_by_service
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/enrollments/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Yoga Class", 125, 8, 156000],
                      ["Pilates", 98, 5, 122500]
                    ],
                    "fields" => [
                      { "name" => "service_name", "type" => "string" },
                      { "name" => "completed_enrollment_count", "type" => "integer" },
                      { "name" => "noshowed_enrollment_count", "type" => "integer" },
                      { "name" => "total_visits_amount", "type" => "currency" }
                    ],
                    "duration" => 0.195,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::Enrollments.query(
              fields: ["completed_enrollment_count", "noshowed_enrollment_count", "total_visits_amount"],
              group: "service_name"
            )

            assert_equal 2, result["data"]["attributes"]["rows"].size
            assert_equal 125, result["data"]["attributes"]["rows"].first[1]
          end

          def test_query_group_by_day_of_week
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/enrollments/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["2024-10-01", 450, 45, 68, 72, 85, 90, 55, 35]
                    ],
                    "fields" => [
                      { "name" => "service_month_start_date", "type" => "date" },
                      { "name" => "enrollment_count", "type" => "integer" },
                      { "name" => "weekday_0_enrollment_count", "type" => "integer" },
                      { "name" => "weekday_1_enrollment_count", "type" => "integer" },
                      { "name" => "weekday_2_enrollment_count", "type" => "integer" },
                      { "name" => "weekday_3_enrollment_count", "type" => "integer" },
                      { "name" => "weekday_4_enrollment_count", "type" => "integer" },
                      { "name" => "weekday_5_enrollment_count", "type" => "integer" },
                      { "name" => "weekday_6_enrollment_count", "type" => "integer" }
                    ],
                    "duration" => 0.210,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::Enrollments.query(
              fields: [
                "enrollment_count",
                "weekday_0_enrollment_count",
                "weekday_1_enrollment_count",
                "weekday_2_enrollment_count",
                "weekday_3_enrollment_count",
                "weekday_4_enrollment_count",
                "weekday_5_enrollment_count",
                "weekday_6_enrollment_count"
              ],
              group: "service_month_start_date"
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal 450, result["data"]["attributes"]["rows"].first[1]
          end

          def test_query_group_by_service_type
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/enrollments/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["group_class", 320, 280],
                      ["appointment", 150, 125]
                    ],
                    "fields" => [
                      { "name" => "service_type", "type" => "enum" },
                      { "name" => "enrollment_count", "type" => "integer" },
                      { "name" => "client_booked_count", "type" => "integer" }
                    ],
                    "duration" => 0.175,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::Enrollments.query(
              fields: ["enrollment_count", "client_booked_count"],
              group: "service_type"
            )

            assert_equal 2, result["data"]["attributes"]["rows"].size
            assert_equal 320, result["data"]["attributes"]["rows"].first[1]
          end

          def test_query_with_pagination
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/enrollments/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      [10050, "Sarah Smith", "Barre"]
                    ],
                    "fields" => [
                      { "name" => "visit_id", "type" => "integer" },
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "service_name", "type" => "string" }
                    ],
                    "duration" => 0.095,
                    "has_more" => true,
                    "last_key" => "enr_10050"
                  }
                }
              }
            )

            result = Pike13::Reporting::Enrollments.query(
              fields: ["visit_id", "full_name", "service_name"],
              page: { limit: 1 }
            )

            assert result["data"]["attributes"]["has_more"]
            assert_equal "enr_10050", result["data"]["attributes"]["last_key"]
          end

          def test_complex_query
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/enrollments/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      [10075, "Mike Johnson", "Advanced Training", "completed", "2024-10-25", true, 3500, "Monthly Membership"]
                    ],
                    "fields" => [
                      { "name" => "visit_id", "type" => "integer" },
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "service_name", "type" => "string" },
                      { "name" => "state", "type" => "enum" },
                      { "name" => "service_date", "type" => "date" },
                      { "name" => "is_paid", "type" => "boolean" },
                      { "name" => "estimated_amount", "type" => "currency" },
                      { "name" => "paid_with", "type" => "string" }
                    ],
                    "duration" => 0.185,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::Enrollments.query(
              fields: [
                "visit_id",
                "full_name",
                "service_name",
                "state",
                "service_date",
                "is_paid",
                "estimated_amount",
                "paid_with"
              ],
              filter: [
                "and",
                [
                  ["btw", "service_date", "2024-01-01", "2024-12-31"],
                  ["eq", "state", "completed"],
                  ["eq", "is_paid", true]
                ]
              ],
              sort: ["service_date-"]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal 8, result["data"]["attributes"]["fields"].size
          end
        end
      end
    end
  end
end
