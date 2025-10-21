# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class PersonTest < Minitest::Test
          def setup
            @client = default_client
          end

          def test_all_people
            stub_pike13_request(:get, "/desk/people", scope: "desk", response_body: {
                                  "people" => [
                                    { "id" => 1, "first_name" => "John" },
                                    { "id" => 2, "first_name" => "Jane" }
                                  ]
                                })

            people = @client.desk.people.all

            assert_instance_of Array, people
            assert_equal 2, people.size
            assert_instance_of Pike13::API::V2::Desk::Person, people.first
          end

          def test_find_person
            stub_pike13_request(:get, "/desk/people/123", scope: "desk", response_body: {
                                  "people" => [{ "id" => 123, "first_name" => "John" }]
                                })

            person = @client.desk.people.find(123)

            assert_instance_of Pike13::API::V2::Desk::Person, person
            assert_equal 123, person.id
          end

          def test_search
            stub_pike13_request(:get, "/desk/people/search?q=john", scope: "desk", response_body: {
                                  "people" => [{ "id" => 123, "first_name" => "John" }]
                                })

            people = @client.desk.people.search("john")

            assert_instance_of Array, people
            assert_equal 1, people.size
          end

          def test_me
            stub_pike13_request(:get, "/desk/people/me", scope: "desk", response_body: {
                                  "people" => [{ "id" => 999, "first_name" => "Admin" }]
                                })

            person = @client.desk.people.me

            assert_instance_of Pike13::API::V2::Desk::Person, person
            assert_equal 999, person.id
          end

          def test_nested_visits
            stub_request(:get, "https://test.pike13.com/api/v2/desk/people/123/visits")
              .with(headers: { "Authorization" => "Bearer test_token" })
              .to_return(status: 200,
                         body: { "visits" => [{ "id" => 456 }] }.to_json,
                         headers: { "Content-Type" => "application/json" })

            person = Pike13::API::V2::Desk::Person.new(session: @client, id: 123)
            visits = person.visits

            assert_instance_of Array, visits
            assert_equal 1, visits.size
          end

          def test_nested_visits_with_params
            stub_request(:get, "https://test.pike13.com/api/v2/desk/people/123/visits?from=2025-01-01&to=2025-01-31")
              .with(headers: { "Authorization" => "Bearer test_token" })
              .to_return(status: 200,
                         body: { "visits" => [{ "id" => 456 }, { "id" => 457 }] }.to_json,
                         headers: { "Content-Type" => "application/json" })

            person = Pike13::API::V2::Desk::Person.new(session: @client, id: 123)
            visits = person.visits(from: "2025-01-01", to: "2025-01-31")

            assert_instance_of Array, visits
            assert_equal 2, visits.size
          end

          def test_nested_plans_with_params
            stub_request(:get, "https://test.pike13.com/api/v2/desk/people/123/plans?include_holds=true&filter=active")
              .with(headers: { "Authorization" => "Bearer test_token" })
              .to_return(status: 200,
                         body: { "plans" => [{ "id" => 789 }] }.to_json,
                         headers: { "Content-Type" => "application/json" })

            person = Pike13::API::V2::Desk::Person.new(session: @client, id: 123)
            plans = person.plans(include_holds: true, filter: "active")

            assert_instance_of Array, plans
            assert_equal 1, plans.size
          end
        end
      end
    end
  end
end
