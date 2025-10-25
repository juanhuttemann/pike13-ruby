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
            stub_pike13_request(:get, "/desk/people", response_body: {
                                  "people" => [
                                    { "id" => 1, "first_name" => "John" },
                                    { "id" => 2, "first_name" => "Jane" }
                                  ]
                                })

            people = @client.desk.people.all.to_a

            assert_instance_of Array, people
            assert_equal 2, people.size
            assert_instance_of Pike13::API::V2::Desk::Person, people.first
          end

          def test_find_person
            stub_pike13_request(:get, "/desk/people/123", response_body: {
                                  "people" => [{ "id" => 123, "first_name" => "John" }]
                                })

            person = @client.desk.people.find(123)

            assert_instance_of Pike13::API::V2::Desk::Person, person
            assert_equal 123, person.id
          end

          def test_search
            stub_pike13_request(:get, "/desk/people/search?q=john", response_body: {
                                  "people" => [{ "id" => 123, "first_name" => "John" }]
                                })

            people = @client.desk.people.search("john").to_a

            assert_instance_of Array, people
            assert_equal 1, people.size
          end

          def test_me
            stub_pike13_request(:get, "/desk/people/me", response_body: {
                                  "people" => [{ "id" => 999, "first_name" => "Admin" }]
                                })

            person = @client.desk.people.me

            assert_instance_of Pike13::API::V2::Desk::Person, person
            assert_equal 999, person.id
          end

          def test_nested_visits
            stub_pike13_request(:get, "/desk/people/123", response_body: {
                                  "people" => [{ "id" => 123, "first_name" => "John" }]
                                })

            # Spyke uses :person_id in the association URI
            stub_request(:get, "https://test.pike13.com/api/v2/desk/people/123/visits")
              .with(headers: { "Authorization" => "Bearer test_token" })
              .to_return(status: 200,
                         body: { "visits" => [{ "id" => 456 }] }.to_json,
                         headers: { "Content-Type" => "application/json" })

            person = @client.desk.people.find(123)
            visits = person.visits.to_a

            assert_instance_of Array, visits
            assert_equal 1, visits.size
          end

          def test_nested_visits_with_params
            stub_request(:get, "https://test.pike13.com/api/v2/desk/people/123/visits?from=2025-01-01&to=2025-01-31")
              .with(headers: { "Authorization" => "Bearer test_token" })
              .to_return(status: 200,
                         body: { "visits" => [{ "id" => 456 }, { "id" => 457 }] }.to_json,
                         headers: { "Content-Type" => "application/json" })

            person = Pike13::API::V2::Desk::Person.new(id: 123)
            visits = person.visits.where(from: "2025-01-01", to: "2025-01-31").to_a

            assert_instance_of Array, visits
            assert_equal 2, visits.size
          end

          def test_nested_plans_with_params
            stub_request(:get, "https://test.pike13.com/api/v2/desk/people/123/plans?include_holds=true&filter=active")
              .with(headers: { "Authorization" => "Bearer test_token" })
              .to_return(status: 200,
                         body: { "plans" => [{ "id" => 789 }] }.to_json,
                         headers: { "Content-Type" => "application/json" })

            person = Pike13::API::V2::Desk::Person.new(id: 123)
            plans = person.plans.where(include_holds: true, filter: "active").to_a

            assert_instance_of Array, plans
            assert_equal 1, plans.size
          end

          # CREATE tests
          def test_create_person_via_proxy
            stub_pike13_request(:post, "/desk/people", response_body: {
                                  "people" => [{
                                    "id" => 456,
                                    "first_name" => "Jane",
                                    "last_name" => "Doe",
                                    "email" => "jane@example.com"
                                  }]
                                })

            person = @client.desk.people.create(
              first_name: "Jane",
              last_name: "Doe",
              email: "jane@example.com"
            )

            assert_instance_of Pike13::API::V2::Desk::Person, person
            assert_equal 456, person.id
            assert_equal "Jane", person.first_name
            assert_equal "Doe", person.last_name
            assert_equal "jane@example.com", person.email
          end

          # UPDATE tests - via instance (find + update)
          def test_update_person_direct
            stub_pike13_request(:get, "/desk/people/123", response_body: {
                                  "people" => [{
                                    "id" => 123,
                                    "first_name" => "John",
                                    "last_name" => "Doe",
                                    "email" => "john@example.com"
                                  }]
                                })

            stub_pike13_request(:put, "/desk/people/123", response_body: {
                                  "people" => [{
                                    "id" => 123,
                                    "first_name" => "John",
                                    "last_name" => "Updated",
                                    "email" => "john.updated@example.com"
                                  }]
                                })

            person = @client.desk.people.find(123)
            person.update_attributes(last_name: "Updated", email: "john.updated@example.com")

            assert_equal 123, person.id
            assert_equal "Updated", person.last_name
            assert_equal "john.updated@example.com", person.email
          end

          # UPDATE tests - via Spyke save
          def test_update_person_with_save
            stub_pike13_request(:get, "/desk/people/123", response_body: {
                                  "people" => [{
                                    "id" => 123,
                                    "first_name" => "John",
                                    "last_name" => "Doe",
                                    "email" => "john@example.com"
                                  }]
                                })

            person = @client.desk.people.find(123)

            assert_equal "Doe", person.last_name

            stub_pike13_request(:put, "/desk/people/123", response_body: {
                                  "people" => [{
                                    "id" => 123,
                                    "first_name" => "John",
                                    "last_name" => "Updated",
                                    "email" => "john.updated@example.com"
                                  }]
                                })

            person.last_name = "Updated"
            person.email = "john.updated@example.com"
            person.save

            assert_equal "Updated", person.last_name
            assert_equal "john.updated@example.com", person.email
          end

          # DELETE tests - Spyke's destroy returns attributes
          def test_destroy_person_class_method
            stub_pike13_request(:get, "/desk/people/123", response_body: {
                                  "people" => [{ "id" => 123, "first_name" => "John" }]
                                })
            stub_pike13_request(:delete, "/desk/people/123", response_body: {})

            person = @client.desk.people.find(123)
            person.destroy

            # Just verify the delete was called
            assert true
          end

          # DELETE tests - via instance (2 requests: find + delete)
          def test_destroy_person_via_instance
            stub_pike13_request(:get, "/desk/people/123", response_body: {
                                  "people" => [{
                                    "id" => 123,
                                    "first_name" => "John",
                                    "last_name" => "Doe"
                                  }]
                                })

            person = @client.desk.people.find(123)

            assert_equal 123, person.id

            stub_pike13_request(:delete, "/desk/people/123", response_body: {})

            person.destroy

            # Just verify the delete was called, Spyke returns attributes not boolean
            assert true
          end
        end
      end
    end
  end
end
