# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V3
      module Desk
        class EventOccurrencesTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_basic_query
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/event_occurrences/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      [10001, "Yoga Flow", "2024-10-15", 15, 20],
                      [10002, "CrossFit WOD", "2024-10-16", 12, 15]
                    ],
                    "fields" => [
                      { "name" => "event_occurrence_id", "type" => "integer" },
                      { "name" => "event_name", "type" => "string" },
                      { "name" => "service_date", "type" => "date" },
                      { "name" => "enrollment_count", "type" => "integer" },
                      { "name" => "capacity", "type" => "integer" }
                    ],
                    "duration" => 0.135,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::EventOccurrences.query(
              fields: ["event_occurrence_id", "event_name", "service_date", "enrollment_count", "capacity"]
            )

            assert_equal 2, result["data"]["attributes"]["rows"].size
            assert_equal 10001, result["data"]["attributes"]["rows"].first[0]
            assert_equal "Yoga Flow", result["data"]["attributes"]["rows"].first[1]
          end

          def test_query_high_attendance_classes
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/event_occurrences/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Spin Class", "2024-10-20", "09:00:00", 18, 20]
                    ],
                    "fields" => [
                      { "name" => "event_name", "type" => "string" },
                      { "name" => "service_date", "type" => "date" },
                      { "name" => "service_time", "type" => "time" },
                      { "name" => "completed_enrollment_count", "type" => "integer" },
                      { "name" => "capacity", "type" => "integer" }
                    ],
                    "duration" => 0.145,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::EventOccurrences.query(
              fields: ["event_name", "service_date", "service_time", "completed_enrollment_count", "capacity"],
              filter: ["gt", "completed_enrollment_count", 15],
              sort: ["completed_enrollment_count-"]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal 18, result["data"]["attributes"]["rows"].first[3]
          end

          def test_query_available_spots
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/event_occurrences/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Pilates Basics", "2024-10-18", 8, 15, "Sarah Johnson"]
                    ],
                    "fields" => [
                      { "name" => "event_name", "type" => "string" },
                      { "name" => "service_date", "type" => "date" },
                      { "name" => "enrollment_count", "type" => "integer" },
                      { "name" => "capacity", "type" => "integer" },
                      { "name" => "instructor_names", "type" => "string" }
                    ],
                    "duration" => 0.125,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::EventOccurrences.query(
              fields: ["event_name", "service_date", "enrollment_count", "capacity", "instructor_names"],
              filter: ["lt", "enrollment_count", "capacity"]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal 8, result["data"]["attributes"]["rows"].first[2]
            assert result["data"]["attributes"]["rows"].first[2] < result["data"]["attributes"]["rows"].first[3]
          end

          def test_query_by_date_and_service_type
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/event_occurrences/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Boxing Basics", "2024-06-15", "18:00:00", 10, "group_class"]
                    ],
                    "fields" => [
                      { "name" => "event_name", "type" => "string" },
                      { "name" => "service_date", "type" => "date" },
                      { "name" => "service_time", "type" => "time" },
                      { "name" => "enrollment_count", "type" => "integer" },
                      { "name" => "service_type", "type" => "enum" }
                    ],
                    "duration" => 0.155,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::EventOccurrences.query(
              fields: ["event_name", "service_date", "service_time", "enrollment_count", "service_type"],
              filter: [
                "and",
                [
                  ["btw", "service_date", "2024-01-01", "2024-12-31"],
                  ["eq", "service_type", "group_class"]
                ]
              ]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal "group_class", result["data"]["attributes"]["rows"].first[4]
          end

          def test_query_attendance_completion
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/event_occurrences/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Morning Yoga", "2024-10-22", true, 14, 2]
                    ],
                    "fields" => [
                      { "name" => "event_name", "type" => "string" },
                      { "name" => "service_date", "type" => "date" },
                      { "name" => "attendance_completed", "type" => "boolean" },
                      { "name" => "completed_enrollment_count", "type" => "integer" },
                      { "name" => "noshowed_enrollment_count", "type" => "integer" }
                    ],
                    "duration" => 0.140,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::EventOccurrences.query(
              fields: ["event_name", "service_date", "attendance_completed", "completed_enrollment_count", "noshowed_enrollment_count"],
              filter: ["eq", "attendance_completed", true]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal true, result["data"]["attributes"]["rows"].first[2]
          end

          def test_query_noshows_and_cancellations
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/event_occurrences/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["HIIT Training", "2024-10-19", 3, 1, 12]
                    ],
                    "fields" => [
                      { "name" => "event_name", "type" => "string" },
                      { "name" => "service_date", "type" => "date" },
                      { "name" => "noshowed_enrollment_count", "type" => "integer" },
                      { "name" => "late_canceled_enrollment_count", "type" => "integer" },
                      { "name" => "enrollment_count", "type" => "integer" }
                    ],
                    "duration" => 0.130,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::EventOccurrences.query(
              fields: ["event_name", "service_date", "noshowed_enrollment_count", "late_canceled_enrollment_count", "enrollment_count"]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal 3, result["data"]["attributes"]["rows"].first[2]
          end

          def test_query_group_by_service_name
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/event_occurrences/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Yoga Flow", 450, 380, 25, 600],
                      ["Spin Class", 320, 285, 18, 450]
                    ],
                    "fields" => [
                      { "name" => "service_name", "type" => "string" },
                      { "name" => "total_enrollment_count", "type" => "integer" },
                      { "name" => "total_completed_enrollment_count", "type" => "integer" },
                      { "name" => "total_noshowed_enrollment_count", "type" => "integer" },
                      { "name" => "total_capacity", "type" => "integer" }
                    ],
                    "duration" => 0.185,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::EventOccurrences.query(
              fields: ["total_enrollment_count", "total_completed_enrollment_count", "total_noshowed_enrollment_count", "total_capacity"],
              group: "service_name"
            )

            assert_equal 2, result["data"]["attributes"]["rows"].size
            assert_equal 450, result["data"]["attributes"]["rows"].first[1]
          end

          def test_query_group_by_instructor
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/event_occurrences/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Mike Thompson", 45, 560, 485],
                      ["Sarah Johnson", 38, 475, 420]
                    ],
                    "fields" => [
                      { "name" => "instructor_names", "type" => "string" },
                      { "name" => "event_occurrence_count", "type" => "integer" },
                      { "name" => "total_enrollment_count", "type" => "integer" },
                      { "name" => "total_completed_enrollment_count", "type" => "integer" }
                    ],
                    "duration" => 0.175,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::EventOccurrences.query(
              fields: ["event_occurrence_count", "total_enrollment_count", "total_completed_enrollment_count"],
              group: "instructor_names"
            )

            assert_equal 2, result["data"]["attributes"]["rows"].size
            assert_equal 45, result["data"]["attributes"]["rows"].first[1]
          end

          def test_query_monthly_summary
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/event_occurrences/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["2024-10-01", 120, 1450, 87.5]
                    ],
                    "fields" => [
                      { "name" => "service_month_start_date", "type" => "date" },
                      { "name" => "event_occurrence_count", "type" => "integer" },
                      { "name" => "total_enrollment_count", "type" => "integer" },
                      { "name" => "total_duration_in_hours", "type" => "float" }
                    ],
                    "duration" => 0.195,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::EventOccurrences.query(
              fields: ["event_occurrence_count", "total_enrollment_count", "total_duration_in_hours"],
              group: "service_month_start_date"
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal 120, result["data"]["attributes"]["rows"].first[1]
          end

          def test_query_with_pagination
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/event_occurrences/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      [50001, "Martial Arts", "2024-10-25"]
                    ],
                    "fields" => [
                      { "name" => "event_occurrence_id", "type" => "integer" },
                      { "name" => "event_name", "type" => "string" },
                      { "name" => "service_date", "type" => "date" }
                    ],
                    "duration" => 0.095,
                    "has_more" => true,
                    "last_key" => "eo_50001"
                  }
                }
              }
            )

            result = Pike13::Reporting::EventOccurrences.query(
              fields: ["event_occurrence_id", "event_name", "service_date"],
              page: { limit: 1 }
            )

            assert result["data"]["attributes"]["has_more"]
            assert_equal "eo_50001", result["data"]["attributes"]["last_key"]
          end

          def test_complex_query
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/event_occurrences/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      [60001, "Advanced CrossFit", "2024-10-28", "10:00:00", 12, 15, true, 11, 1]
                    ],
                    "fields" => [
                      { "name" => "event_occurrence_id", "type" => "integer" },
                      { "name" => "event_name", "type" => "string" },
                      { "name" => "service_date", "type" => "date" },
                      { "name" => "service_time", "type" => "time" },
                      { "name" => "enrollment_count", "type" => "integer" },
                      { "name" => "capacity", "type" => "integer" },
                      { "name" => "attendance_completed", "type" => "boolean" },
                      { "name" => "completed_enrollment_count", "type" => "integer" },
                      { "name" => "noshowed_enrollment_count", "type" => "integer" }
                    ],
                    "duration" => 0.210,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::EventOccurrences.query(
              fields: [
                "event_occurrence_id",
                "event_name",
                "service_date",
                "service_time",
                "enrollment_count",
                "capacity",
                "attendance_completed",
                "completed_enrollment_count",
                "noshowed_enrollment_count"
              ],
              filter: [
                "and",
                [
                  ["btw", "service_date", "2024-01-01", "2024-12-31"],
                  ["eq", "attendance_completed", true],
                  ["gt", "enrollment_count", 10]
                ]
              ],
              sort: ["service_date-"]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal 9, result["data"]["attributes"]["fields"].size
            assert_equal true, result["data"]["attributes"]["rows"].first[6]
          end
        end
      end
    end
  end
end
