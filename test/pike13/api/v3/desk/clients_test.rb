# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V3
      module Desk
        class ClientsTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_basic_query
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/clients/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      [123, "John Smith", "john@example.com", "555-0100", "2020-01-15"],
                      [456, "Jane Doe", "jane@example.com", "555-0200", "2021-03-20"]
                    ],
                    "fields" => [
                      { "name" => "person_id", "type" => "integer" },
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "email", "type" => "string" },
                      { "name" => "phone", "type" => "string" },
                      { "name" => "client_since_date", "type" => "date" }
                    ],
                    "duration" => 0.115,
                    "has_more" => false,
                    "last_key" => "client_456"
                  }
                }
              }
            )

            result = Pike13::Reporting::Clients.query(
              fields: ["person_id", "full_name", "email", "phone", "client_since_date"]
            )

            assert_equal 2, result["data"]["attributes"]["rows"].size
            assert_equal 123, result["data"]["attributes"]["rows"].first[0]
            assert_equal "John Smith", result["data"]["attributes"]["rows"].first[1]
          end

          def test_query_with_membership_filter
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/clients/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Alice Johnson", "alice@example.com", true, 1250, 85]
                    ],
                    "fields" => [
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "email", "type" => "string" },
                      { "name" => "has_membership", "type" => "boolean" },
                      { "name" => "tenure", "type" => "integer" },
                      { "name" => "completed_visits", "type" => "integer" }
                    ],
                    "duration" => 0.125,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::Clients.query(
              fields: ["full_name", "email", "has_membership", "tenure", "completed_visits"],
              filter: ["eq", "has_membership", true]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert result["data"]["attributes"]["rows"].first[2] # has_membership is true
          end

          def test_query_with_unpaid_invoice_filter
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/clients/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Bob Williams", "bob@example.com", 15000, "2024-10-15"]
                    ],
                    "fields" => [
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "email", "type" => "string" },
                      { "name" => "last_invoice_amount", "type" => "currency" },
                      { "name" => "last_invoice_date", "type" => "date" }
                    ],
                    "duration" => 0.130,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::Clients.query(
              fields: ["full_name", "email", "last_invoice_amount", "last_invoice_date"],
              filter: [
                "and",
                [
                  ["eq", "person_state", "active"],
                  ["eq", "last_invoice_unpaid", true]
                ]
              ]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal 15000, result["data"]["attributes"]["rows"].first[2]
          end

          def test_query_with_tenure_group_filter
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/clients/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["Carol Davis", "carol@example.com", 1825, "5_over_three_years", 250]
                    ],
                    "fields" => [
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "email", "type" => "string" },
                      { "name" => "tenure", "type" => "integer" },
                      { "name" => "tenure_group", "type" => "enum" },
                      { "name" => "completed_visits", "type" => "integer" }
                    ],
                    "duration" => 0.140,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::Clients.query(
              fields: ["full_name", "email", "tenure", "tenure_group", "completed_visits"],
              filter: ["eq", "tenure_group", "5_over_three_years"],
              sort: ["completed_visits-"]
            )

            assert_equal 1, result["data"]["attributes"]["rows"].size
            assert_equal "5_over_three_years", result["data"]["attributes"]["rows"].first[3]
          end

          def test_query_with_grouping
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/clients/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      ["5_over_three_years", 450, 320, 18750],
                      ["4_three_years", 280, 200, 11500]
                    ],
                    "fields" => [
                      { "name" => "tenure_group", "type" => "enum" },
                      { "name" => "person_count", "type" => "integer" },
                      { "name" => "has_membership_count", "type" => "integer" },
                      { "name" => "total_completed_visits", "type" => "integer" }
                    ],
                    "duration" => 0.180,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::Clients.query(
              fields: ["person_count", "has_membership_count", "total_completed_visits"],
              group: "tenure_group"
            )

            assert_equal 2, result["data"]["attributes"]["rows"].size
            assert_equal 450, result["data"]["attributes"]["rows"].first[1]
          end

          def test_query_with_name_search
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/clients/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      [789, "Sarah Smith", "sarah@example.com", "555-0300"],
                      [101, "Mike Smith", "mike@example.com", "555-0400"]
                    ],
                    "fields" => [
                      { "name" => "person_id", "type" => "integer" },
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "email", "type" => "string" },
                      { "name" => "phone", "type" => "string" }
                    ],
                    "duration" => 0.095,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::Clients.query(
              fields: ["person_id", "full_name", "email", "phone"],
              filter: ["contains", "full_name", "Smith"]
            )

            assert_equal 2, result["data"]["attributes"]["rows"].size
            assert result["data"]["attributes"]["rows"].first[1].include?("Smith")
          end

          def test_query_with_pagination
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/clients/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      [111, "Client One", "one@example.com"]
                    ],
                    "fields" => [
                      { "name" => "person_id", "type" => "integer" },
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "email", "type" => "string" }
                    ],
                    "duration" => 0.075,
                    "has_more" => true,
                    "last_key" => "client_111"
                  }
                }
              }
            )

            result = Pike13::Reporting::Clients.query(
              fields: ["person_id", "full_name", "email"],
              page: { limit: 1 }
            )

            assert result["data"]["attributes"]["has_more"]
            assert_equal "client_111", result["data"]["attributes"]["last_key"]
          end

          def test_complex_query
            stub_pike13_request(
              :post,
              "https://test.pike13.com/desk/api/v3/reports/clients/queries",
              response_body: {
                "data" => {
                  "attributes" => {
                    "rows" => [
                      [222, "Active Member", "member@example.com", true, 850, 75000, "2020-06-01"]
                    ],
                    "fields" => [
                      { "name" => "person_id", "type" => "integer" },
                      { "name" => "full_name", "type" => "string" },
                      { "name" => "email", "type" => "string" },
                      { "name" => "has_membership", "type" => "boolean" },
                      { "name" => "tenure", "type" => "integer" },
                      { "name" => "net_paid_amount", "type" => "currency" },
                      { "name" => "client_since_date", "type" => "date" }
                    ],
                    "duration" => 0.165,
                    "has_more" => false,
                    "last_key" => nil
                  }
                }
              }
            )

            result = Pike13::Reporting::Clients.query(
              fields: [
                "person_id",
                "full_name",
                "email",
                "has_membership",
                "tenure",
                "net_paid_amount",
                "client_since_date"
              ],
              filter: [
                "and",
                [
                  ["eq", "person_state", "active"],
                  ["eq", "has_membership", true],
                  ["gt", "completed_visits", 50]
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
