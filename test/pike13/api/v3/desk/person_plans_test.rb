# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V3
      module Desk
        class PersonPlansTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_basic_query
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/person_plans/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      [12345, "John Smith", "Monthly Membership", true, "2024-01-15"],
                      [12346, "Jane Doe", "10 Class Pack", true, "2024-02-01"]
                    ],
                    "fields" => [
                      { "name" => "person_plan_id", "type" => "integer" },
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "plan_name", "type" => "string" },
                      { "name" => "is_available", "type" => "boolean" },
                      { "name" => "start_date", "type" => "date" }
                    ],
                    "duration" => 0.125,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::PersonPlans.query(
              fields: ["person_plan_id", "full_name", "plan_name", "is_available", "start_date"]
            )

            assert_equal 2, result["data"]["attributes"]["rows"].size
            assert_equal 12345, result["data"]["attributes"]["rows"].first[0]
            assert_equal "John Smith", result["data"]["attributes"]["rows"].first[1]
          end

          def test_query_available_memberships
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/person_plans/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Alice Johnson", "Premium Membership", "2024-03-01", "2025-03-01", 12]
                    ],
                    "fields" => [
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "plan_name", "type" => "string" },
                      { "name" => "start_date", "type" => "date" },
                      { "name" => "end_date", "type" => "date" },
                      { "name" => "remaining_visit_count", "type" => "integer" }
                    ],
                    "duration" => 0.145,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::PersonPlans.query(
              fields: ["full_name", "plan_name", "start_date", "end_date", "remaining_visit_count"],
              filter: [
                "and",
                [
                  ["eq", "is_available", true],
                  ["eq", "grants_membership", true]
                ]
              ]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal 12, result["data"]["attributes"]["rows"].first[4]
          end

          def test_query_plans_on_hold
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/person_plans/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Bob Wilson", "Annual Pass", "2024-06-01", "2024-07-01", "Staff Member"]
                    ],
                    "fields" => [
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "plan_name", "type" => "string" },
                      { "name" => "last_hold_start_date", "type" => "date" },
                      { "name" => "last_hold_end_date", "type" => "date" },
                      { "name" => "last_hold_by", "type" => "string" }
                    ],
                    "duration" => 0.135,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::PersonPlans.query(
              fields: ["full_name", "plan_name", "last_hold_start_date", "last_hold_end_date", "last_hold_by"],
              filter: ["eq", "is_on_hold", true]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal "2024-06-01", result["data"]["attributes"]["rows"].first[2]
          end

          def test_query_past_due_invoices
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/person_plans/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Carol Davis", "carol@example.com", "Monthly Membership", "2024-09-15", 7500]
                    ],
                    "fields" => [
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "email", "type" => "string" },
                      { "name" => "plan_name", "type" => "string" },
                      { "name" => "latest_invoice_due_date", "type" => "date" },
                      { "name" => "latest_invoice_item_amount", "type" => "currency" }
                    ],
                    "duration" => 0.155,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::PersonPlans.query(
              fields: ["full_name", "email", "plan_name", "latest_invoice_due_date", "latest_invoice_item_amount"],
              filter: ["eq", "latest_invoice_past_due", true],
              sort: ["latest_invoice_due_date+"]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert result["data"]["attributes"]["rows"].first[1].include?("@")
          end

          def test_query_plan_usage
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/person_plans/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["David Lee", "10 Class Pack", 10, 7, 3, "2024-08-20"]
                    ],
                    "fields" => [
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "plan_name", "type" => "string" },
                      { "name" => "allowed_visit_count", "type" => "integer" },
                      { "name" => "used_visit_count", "type" => "integer" },
                      { "name" => "remaining_visit_count", "type" => "integer" },
                      { "name" => "last_visit_date", "type" => "date" }
                    ],
                    "duration" => 0.140,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::PersonPlans.query(
              fields: ["full_name", "plan_name", "allowed_visit_count", "used_visit_count", "remaining_visit_count", "last_visit_date"],
              filter: ["gt", "used_visit_count", 0]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal 7, result["data"]["attributes"]["rows"].first[3]
            assert_equal 3, result["data"]["attributes"]["rows"].first[4]
          end

          def test_query_group_by_plan_type
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/person_plans/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["unlimited_plan", 250, 225, 15],
                      ["punchcard", 180, 120, 45]
                    ],
                    "fields" => [
                      { "name" => "plan_type", "type" => "enum" },
                      { "name" => "person_plan_count", "type" => "integer" },
                      { "name" => "is_available_count", "type" => "integer" },
                      { "name" => "is_on_hold_count", "type" => "integer" }
                    ],
                    "duration" => 0.185,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::PersonPlans.query(
              fields: ["person_plan_count", "is_available_count", "is_on_hold_count"],
              group: "plan_type"
            )

            assert_equal 2, result["data"]["attributes"]["rows"].size
            assert_equal 250, result["data"]["attributes"]["rows"].first[1]
            assert_equal 225, result["data"]["attributes"]["rows"].first[2]
          end

          def test_query_plan_retention
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/person_plans/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Emily Brown", "Premium Membership", "2025-01-01", "Unlimited Plan", "Premium Plus"]
                    ],
                    "fields" => [
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "plan_name", "type" => "string" },
                      { "name" => "next_plan_start_date", "type" => "date" },
                      { "name" => "next_plan_type", "type" => "string" },
                      { "name" => "next_plan_name", "type" => "string" }
                    ],
                    "duration" => 0.165,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::PersonPlans.query(
              fields: ["full_name", "plan_name", "next_plan_start_date", "next_plan_type", "next_plan_name"],
              filter: ["not_null", "next_plan_id"]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal "2025-01-01", result["data"]["attributes"]["rows"].first[2]
          end

          def test_query_first_time_members
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/person_plans/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Frank Miller", "frank@example.com", "Starter Pack", "2024-10-01", "2024-10-05", 4]
                    ],
                    "fields" => [
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "email", "type" => "string" },
                      { "name" => "plan_name", "type" => "string" },
                      { "name" => "start_date", "type" => "date" },
                      { "name" => "first_visit_date", "type" => "date" },
                      { "name" => "start_date_to_first_visit", "type" => "integer" }
                    ],
                    "duration" => 0.130,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::PersonPlans.query(
              fields: ["full_name", "email", "plan_name", "start_date", "first_visit_date", "start_date_to_first_visit"],
              filter: [
                "and",
                [
                  ["eq", "is_first_membership", true],
                  ["eq", "grants_membership", true]
                ]
              ]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal 4, result["data"]["attributes"]["rows"].first[5]
          end

          def test_query_with_pagination
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/person_plans/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      [54321, "Grace Taylor", "Monthly Membership"]
                    ],
                    "fields" => [
                      { "name" => "person_plan_id", "type" => "integer" },
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "plan_name", "type" => "string" }
                    ],
                    "duration" => 0.095,
                    "has_more" => true,
                    "last_key" => "pp_54321"
                  }
                }
              }
            )

            result = Pike13::Reporting::PersonPlans.query(
              fields: ["person_plan_id", "full_name", "plan_name"],
              page: { limit: 1 }
            )

            assert result["data"]["attributes"]["has_more"]
            assert_equal "pp_54321", result["data"]["attributes"]["last_key"]
          end

          def test_complex_query
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/person_plans/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      [67890, "Helen Garcia", "helen@example.com", "Unlimited Membership", true, false, 10, 8, "2024-09-30"]
                    ],
                    "fields" => [
                      { "name" => "person_plan_id", "type" => "integer" },
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "email", "type" => "string" },
                      { "name" => "plan_name", "type" => "string" },
                      { "name" => "is_available", "type" => "boolean" },
                      { "name" => "is_on_hold", "type" => "boolean" },
                      { "name" => "allowed_visit_count", "type" => "integer" },
                      { "name" => "used_visit_count", "type" => "integer" },
                      { "name" => "last_visit_date", "type" => "date" }
                    ],
                    "duration" => 0.195,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::PersonPlans.query(
              fields: [
                "person_plan_id",
                "full_name",
                "email",
                "plan_name",
                "is_available",
                "is_on_hold",
                "allowed_visit_count",
                "used_visit_count",
                "last_visit_date"
              ],
              filter: [
                "and",
                [
                  ["eq", "is_available", true],
                  ["eq", "grants_membership", true],
                  ["btw", "start_date", "2024-01-01", "2024-12-31"]
                ]
              ],
              sort: ["last_visit_date-"]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal 9, result["data"]["attributes"]["fields"].size
            assert_equal true, result["data"]["attributes"]["rows"].first[4]
          end
        end
      end
    end
  end
end
