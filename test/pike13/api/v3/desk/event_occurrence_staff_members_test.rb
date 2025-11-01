# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V3
      module Desk
        class EventOccurrenceStaffMembersTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_basic_query
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/event_occurrence_staff_members/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      [10001, "Sarah Johnson", "Yoga Flow", "2024-10-15", 15],
                      [10002, "Mike Thompson", "CrossFit WOD", "2024-10-16", 12]
                    ],
                    "fields" => [
                      { "name" => "event_occurrence_id", "type" => "integer" },
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "event_name", "type" => "string" },
                      { "name" => "service_date", "type" => "date" },
                      { "name" => "enrollment_count", "type" => "integer" }
                    ],
                    "duration" => 0.145,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::EventOccurrenceStaffMembers.query(
              fields: ["event_occurrence_id", "full_name", "event_name", "service_date", "enrollment_count"]
            )

            assert_equal 2, result["data"]["attributes"]["rows"].size
            assert_equal "Sarah Johnson", result["data"]["attributes"]["rows"].first[1]
          end

          def test_query_by_staff_member
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/event_occurrence_staff_members/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Sarah Johnson", "Yoga Flow", "2024-10-20", "09:00:00", 18, "owner"]
                    ],
                    "fields" => [
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "event_name", "type" => "string" },
                      { "name" => "service_date", "type" => "date" },
                      { "name" => "service_time", "type" => "time" },
                      { "name" => "completed_enrollment_count", "type" => "integer" },
                      { "name" => "role", "type" => "enum" }
                    ],
                    "duration" => 0.135,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::EventOccurrenceStaffMembers.query(
              fields: ["full_name", "event_name", "service_date", "service_time", "completed_enrollment_count", "role"],
              filter: ["eq", "person_id", 12345],
              sort: ["service_date-"]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal "owner", result["data"]["attributes"]["rows"].first[5]
          end

          def test_query_with_contact_info
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/event_occurrence_staff_members/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Mike Thompson", "mike@example.com", "555-0123", "Boxing Basics", "2024-10-18", 10]
                    ],
                    "fields" => [
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "email", "type" => "string" },
                      { "name" => "phone", "type" => "string" },
                      { "name" => "event_name", "type" => "string" },
                      { "name" => "service_date", "type" => "date" },
                      { "name" => "enrollment_count", "type" => "integer" }
                    ],
                    "duration" => 0.125,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::EventOccurrenceStaffMembers.query(
              fields: ["full_name", "email", "phone", "event_name", "service_date", "enrollment_count"]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert result["data"]["attributes"]["rows"].first[1].include?("@")
          end

          def test_query_by_role_and_date
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/event_occurrence_staff_members/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Alice Williams", "owner", "Spin Class", "2024-06-15", 20]
                    ],
                    "fields" => [
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "role", "type" => "enum" },
                      { "name" => "event_name", "type" => "string" },
                      { "name" => "service_date", "type" => "date" },
                      { "name" => "completed_enrollment_count", "type" => "integer" }
                    ],
                    "duration" => 0.155,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::EventOccurrenceStaffMembers.query(
              fields: ["full_name", "role", "event_name", "service_date", "completed_enrollment_count"],
              filter: [
                "and",
                [
                  ["eq", "role", "owner"],
                  ["btw", "service_date", "2024-01-01", "2024-12-31"]
                ]
              ]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal "owner", result["data"]["attributes"]["rows"].first[1]
          end

          def test_query_attendance_completion
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/event_occurrence_staff_members/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Bob Martinez", "Morning Yoga", "2024-10-22", true, 14, 2]
                    ],
                    "fields" => [
                      { "name" => "full_name", "type" => "string" },
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

            result = Pike13::Reporting::EventOccurrenceStaffMembers.query(
              fields: ["full_name", "event_name", "service_date", "attendance_completed", "completed_enrollment_count", "noshowed_enrollment_count"]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal true, result["data"]["attributes"]["rows"].first[3]
          end

          def test_query_workload_analysis
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/event_occurrence_staff_members/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Carol Davis", "HIIT Training", "2024-10-19", 1.5, 15, 20]
                    ],
                    "fields" => [
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "event_name", "type" => "string" },
                      { "name" => "service_date", "type" => "date" },
                      { "name" => "duration_in_hours", "type" => "float" },
                      { "name" => "enrollment_count", "type" => "integer" },
                      { "name" => "capacity", "type" => "integer" }
                    ],
                    "duration" => 0.130,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::EventOccurrenceStaffMembers.query(
              fields: ["full_name", "event_name", "service_date", "duration_in_hours", "enrollment_count", "capacity"]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal 1.5, result["data"]["attributes"]["rows"].first[3]
          end

          def test_query_group_by_staff_member
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/event_occurrence_staff_members/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Sarah Johnson", 45, 560, 485, 67.5],
                      ["Mike Thompson", 38, 475, 420, 57.0]
                    ],
                    "fields" => [
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "event_occurrence_count", "type" => "integer" },
                      { "name" => "total_enrollment_count", "type" => "integer" },
                      { "name" => "total_completed_enrollment_count", "type" => "integer" },
                      { "name" => "total_duration_in_hours", "type" => "float" }
                    ],
                    "duration" => 0.185,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::EventOccurrenceStaffMembers.query(
              fields: ["event_occurrence_count", "total_enrollment_count", "total_completed_enrollment_count", "total_duration_in_hours"],
              group: "full_name"
            )

            assert_equal 2, result["data"]["attributes"]["rows"].size
            assert_equal 45, result["data"]["attributes"]["rows"].first[1]
          end

          def test_query_group_by_service
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/event_occurrence_staff_members/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Yoga Flow", 3, 30, 450],
                      ["Spin Class", 2, 25, 320]
                    ],
                    "fields" => [
                      { "name" => "service_name", "type" => "string" },
                      { "name" => "person_count", "type" => "integer" },
                      { "name" => "event_occurrence_count", "type" => "integer" },
                      { "name" => "total_enrollment_count", "type" => "integer" }
                    ],
                    "duration" => 0.175,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::EventOccurrenceStaffMembers.query(
              fields: ["person_count", "event_occurrence_count", "total_enrollment_count"],
              group: "service_name"
            )

            assert_equal 2, result["data"]["attributes"]["rows"].size
            assert_equal 3, result["data"]["attributes"]["rows"].first[1]
          end

          def test_query_group_by_role
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/event_occurrence_staff_members/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["owner", 5, 120, 180.0],
                      ["standard", 8, 95, 142.5]
                    ],
                    "fields" => [
                      { "name" => "role", "type" => "enum" },
                      { "name" => "person_count", "type" => "integer" },
                      { "name" => "event_occurrence_count", "type" => "integer" },
                      { "name" => "total_duration_in_hours", "type" => "float" }
                    ],
                    "duration" => 0.165,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::EventOccurrenceStaffMembers.query(
              fields: ["person_count", "event_occurrence_count", "total_duration_in_hours"],
              group: "role"
            )

            assert_equal 2, result["data"]["attributes"]["rows"].size
            assert_equal "owner", result["data"]["attributes"]["rows"].first[0]
          end

          def test_query_with_pagination
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/event_occurrence_staff_members/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      [50001, "David Lee", "Martial Arts"]
                    ],
                    "fields" => [
                      { "name" => "event_occurrence_id", "type" => "integer" },
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "event_name", "type" => "string" }
                    ],
                    "duration" => 0.095,
                    "has_more" => true,
                    "last_key" => "eosm_50001"
                  }
                }
              }
            )

            result = Pike13::Reporting::EventOccurrenceStaffMembers.query(
              fields: ["event_occurrence_id", "full_name", "event_name"],
              page: { limit: 1 }
            )

            assert result["data"]["attributes"]["has_more"]
            assert_equal "eosm_50001", result["data"]["attributes"]["last_key"]
          end

          def test_complex_query
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/event_occurrence_staff_members/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      [60001, "Emily Brown", "emily@example.com", "owner", "Advanced Training", "2024-10-28", 15, 20, true]
                    ],
                    "fields" => [
                      { "name" => "event_occurrence_id", "type" => "integer" },
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "email", "type" => "string" },
                      { "name" => "role", "type" => "enum" },
                      { "name" => "event_name", "type" => "string" },
                      { "name" => "service_date", "type" => "date" },
                      { "name" => "enrollment_count", "type" => "integer" },
                      { "name" => "capacity", "type" => "integer" },
                      { "name" => "attendance_completed", "type" => "boolean" }
                    ],
                    "duration" => 0.210,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::EventOccurrenceStaffMembers.query(
              fields: [
                "event_occurrence_id",
                "full_name",
                "email",
                "role",
                "event_name",
                "service_date",
                "enrollment_count",
                "capacity",
                "attendance_completed"
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
            assert_equal "owner", result["data"]["attributes"]["rows"].first[3]
          end
        end
      end
    end
  end
end
