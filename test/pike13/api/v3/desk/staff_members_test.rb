# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V3
      module Desk
        class StaffMembersTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_basic_query
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/staff_members/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      [12345, "Sarah Johnson", "sarah@example.com", "manager", "active"],
                      [12346, "Mike Thompson", "mike@example.com", "standard", "active"]
                    ],
                    "fields" => [
                      { "name" => "person_id", "type" => "integer" },
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "email", "type" => "string" },
                      { "name" => "role", "type" => "enum" },
                      { "name" => "person_state", "type" => "enum" }
                    ],
                    "duration" => 0.145,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::StaffMembers.query(
              fields: ["person_id", "full_name", "email", "role", "person_state"]
            )

            assert_equal 2, result["data"]["attributes"]["rows"].size
            assert_equal 12345, result["data"]["attributes"]["rows"].first[0]
            assert_equal "Sarah Johnson", result["data"]["attributes"]["rows"].first[1]
          end

          def test_query_active_staff_with_event_counts
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/staff_members/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Sarah Johnson", "sarah@example.com", "manager", 365, 25, 120]
                    ],
                    "fields" => [
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "email", "type" => "string" },
                      { "name" => "role", "type" => "enum" },
                      { "name" => "tenure", "type" => "integer" },
                      { "name" => "future_events", "type" => "integer" },
                      { "name" => "past_events", "type" => "integer" }
                    ],
                    "duration" => 0.135,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::StaffMembers.query(
              fields: ["full_name", "email", "role", "tenure", "future_events", "past_events"],
              filter: ["eq", "person_state", "active"],
              sort: ["tenure-"]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal 365, result["data"]["attributes"]["rows"].first[3]
          end

          def test_query_staff_shown_to_clients
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/staff_members/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Bob Wilson", "bob@example.com", "standard", "Downtown Location"]
                    ],
                    "fields" => [
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "email", "type" => "string" },
                      { "name" => "role", "type" => "enum" },
                      { "name" => "home_location_name", "type" => "string" }
                    ],
                    "duration" => 0.125,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::StaffMembers.query(
              fields: ["full_name", "email", "role", "home_location_name"],
              filter: ["eq", "show_to_clients", true]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal "Downtown Location", result["data"]["attributes"]["rows"].first[3]
          end

          def test_query_by_role
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/staff_members/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Alice Brown", "alice@example.com", 730, 30],
                      ["David Lee", "david@example.com", 456, 22]
                    ],
                    "fields" => [
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "email", "type" => "string" },
                      { "name" => "tenure", "type" => "integer" },
                      { "name" => "future_events", "type" => "integer" }
                    ],
                    "duration" => 0.155,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::StaffMembers.query(
              fields: ["full_name", "email", "tenure", "future_events"],
              filter: ["in", "role", ["manager", "owner", "primary_owner"]]
            )

            assert_equal 2, result["data"]["attributes"]["rows"].size
            assert_equal 730, result["data"]["attributes"]["rows"].first[2]
          end

          def test_query_upcoming_birthdays
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/staff_members/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Emily Chen", "emily@example.com", "1990-11-15", 15],
                      ["Frank Miller", "frank@example.com", "1985-11-25", 25]
                    ],
                    "fields" => [
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "email", "type" => "string" },
                      { "name" => "birthdate", "type" => "date" },
                      { "name" => "days_until_birthday", "type" => "integer" }
                    ],
                    "duration" => 0.140,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::StaffMembers.query(
              fields: ["full_name", "email", "birthdate", "days_until_birthday"],
              filter: ["lte", "days_until_birthday", 30],
              sort: ["days_until_birthday+"]
            )

            assert_equal 2, result["data"]["attributes"]["rows"].size
            assert_equal 15, result["data"]["attributes"]["rows"].first[3]
          end

          def test_query_staff_tenure
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/staff_members/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Grace Taylor", "2022-01-15", 1020, "5_over_three_years", 145]
                    ],
                    "fields" => [
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "staff_since_date", "type" => "date" },
                      { "name" => "tenure", "type" => "integer" },
                      { "name" => "tenure_group", "type" => "enum" },
                      { "name" => "past_events", "type" => "integer" }
                    ],
                    "duration" => 0.130,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::StaffMembers.query(
              fields: ["full_name", "staff_since_date", "tenure", "tenure_group", "past_events"],
              filter: ["eq", "person_state", "active"],
              sort: ["tenure-"]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal 1020, result["data"]["attributes"]["rows"].first[2]
          end

          def test_query_staff_who_are_also_clients
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/staff_members/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Helen White", "helen@example.com", "standard", "North Location"]
                    ],
                    "fields" => [
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "email", "type" => "string" },
                      { "name" => "role", "type" => "enum" },
                      { "name" => "home_location_name", "type" => "string" }
                    ],
                    "duration" => 0.125,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::StaffMembers.query(
              fields: ["full_name", "email", "role", "home_location_name"],
              filter: ["eq", "also_client", true]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert result["data"]["attributes"]["rows"].first[3].include?("Location")
          end

          def test_query_group_by_role
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/staff_members/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["manager", 5, 125, 450],
                      ["standard", 15, 180, 1250]
                    ],
                    "fields" => [
                      { "name" => "role", "type" => "enum" },
                      { "name" => "person_count", "type" => "integer" },
                      { "name" => "total_future_events", "type" => "integer" },
                      { "name" => "total_past_events", "type" => "integer" }
                    ],
                    "duration" => 0.185,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::StaffMembers.query(
              fields: ["person_count", "total_future_events", "total_past_events"],
              group: "role"
            )

            assert_equal 2, result["data"]["attributes"]["rows"].size
            assert_equal 5, result["data"]["attributes"]["rows"].first[1]
          end

          def test_query_group_by_tenure_group
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/staff_members/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["5_over_three_years", 8, 120, 3],
                      ["2_year", 6, 85, 2]
                    ],
                    "fields" => [
                      { "name" => "tenure_group", "type" => "enum" },
                      { "name" => "person_count", "type" => "integer" },
                      { "name" => "total_future_events", "type" => "integer" },
                      { "name" => "also_client_count", "type" => "integer" }
                    ],
                    "duration" => 0.175,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::StaffMembers.query(
              fields: ["person_count", "total_future_events", "also_client_count"],
              group: "tenure_group"
            )

            assert_equal 2, result["data"]["attributes"]["rows"].size
            assert_equal "5_over_three_years", result["data"]["attributes"]["rows"].first[0]
          end

          def test_query_group_by_location
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/staff_members/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Downtown Location", 12, 156, 890],
                      ["North Location", 8, 95, 620]
                    ],
                    "fields" => [
                      { "name" => "home_location_name", "type" => "string" },
                      { "name" => "person_count", "type" => "integer" },
                      { "name" => "total_future_events", "type" => "integer" },
                      { "name" => "total_past_events", "type" => "integer" }
                    ],
                    "duration" => 0.195,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::StaffMembers.query(
              fields: ["person_count", "total_future_events", "total_past_events"],
              group: "home_location_name"
            )

            assert_equal 2, result["data"]["attributes"]["rows"].size
            assert_equal 12, result["data"]["attributes"]["rows"].first[1]
          end

          def test_query_with_pagination
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/staff_members/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      [60001, "Ian Martinez", "standard"]
                    ],
                    "fields" => [
                      { "name" => "person_id", "type" => "integer" },
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "role", "type" => "enum" }
                    ],
                    "duration" => 0.095,
                    "has_more" => true,
                    "last_key" => "staff_60001"
                  }
                }
              }
            )

            result = Pike13::Reporting::StaffMembers.query(
              fields: ["person_id", "full_name", "role"],
              page: { limit: 1 }
            )

            assert result["data"]["attributes"]["has_more"]
            assert_equal "staff_60001", result["data"]["attributes"]["last_key"]
          end

          def test_complex_query
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/staff_members/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      [70001, "Jessica Anderson", "manager", "active", "jessica@example.com", 25, 180, true]
                    ],
                    "fields" => [
                      { "name" => "person_id", "type" => "integer" },
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "role", "type" => "enum" },
                      { "name" => "person_state", "type" => "enum" },
                      { "name" => "email", "type" => "string" },
                      { "name" => "future_events", "type" => "integer" },
                      { "name" => "past_events", "type" => "integer" },
                      { "name" => "show_to_clients", "type" => "boolean" }
                    ],
                    "duration" => 0.210,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::StaffMembers.query(
              fields: [
                "person_id",
                "full_name",
                "role",
                "person_state",
                "email",
                "future_events",
                "past_events",
                "show_to_clients"
              ],
              filter: [
                "and",
                [
                  ["eq", "person_state", "active"],
                  ["eq", "show_to_clients", true],
                  ["gt", "future_events", 10]
                ]
              ],
              sort: ["future_events-"]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal 8, result["data"]["attributes"]["fields"].size
            assert_equal 25, result["data"]["attributes"]["rows"].first[5]
          end
        end
      end
    end
  end
end
