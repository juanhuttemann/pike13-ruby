# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class PersonTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_all_people
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/people", response_body: {
                                  "people" => [
                                    { "id" => 1, "first_name" => "John" },
                                    { "id" => 2, "first_name" => "Jane" }
                                  ]
                                })

            people = Pike13::API::V2::Desk::Person.all

            assert_instance_of Hash, people
            assert_equal 2, people["people"].size
            assert_instance_of Hash, people["people"].first
          end

          def test_find_person
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/people/123", response_body: {
                                  "people" => [{ "id" => 123, "first_name" => "John" }]
                                })

            person = Pike13::API::V2::Desk::Person.find(123)

            assert_instance_of Hash, person
            assert_equal 123, person["people"].first["id"]
          end

          def test_search
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/people/search?q=john", response_body: {
                                  "people" => [{ "id" => 123, "first_name" => "John" }]
                                })

            people = Pike13::API::V2::Desk::Person.search("john")

            assert_instance_of Hash, people
            assert_equal 1, people["people"].size
          end

          def test_me
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/people/me", response_body: {
                                  "people" => [{ "id" => 999, "first_name" => "Admin" }]
                                })

            person = Pike13::API::V2::Desk::Person.me

            assert_instance_of Hash, person
            assert_equal 999, person["people"].first["id"]
          end

          # NOTE: Nested resources are no longer supported via instance associations
          # Use Visit.all(person_id: 123) or Plan.all(person_id: 123) instead

          # CREATE tests
          def test_create_person_via_proxy
            stub_pike13_request(:post, "https://test.pike13.com/api/v2/desk/people", response_body: {
                                  "people" => [{
                                    "id" => 456,
                                    "first_name" => "Jane",
                                    "last_name" => "Doe",
                                    "email" => "jane@example.com"
                                  }]
                                })

            person = Pike13::API::V2::Desk::Person.create(
              first_name: "Jane",
              last_name: "Doe",
              email: "jane@example.com"
            )

            assert_instance_of Hash, person
            assert_equal 456, person["people"].first["id"]
            assert_equal "Jane", person["people"].first["first_name"]
            assert_equal "Doe", person["people"].first["last_name"]
            assert_equal "jane@example.com", person["people"].first["email"]
          end

          # UPDATE tests - direct class method
          def test_update_person_direct
            stub_pike13_request(:put, "https://test.pike13.com/api/v2/desk/people/123", response_body: {
                                  "people" => [{
                                    "id" => 123,
                                    "first_name" => "John",
                                    "last_name" => "Updated",
                                    "email" => "john.updated@example.com"
                                  }]
                                })

            person = Pike13::API::V2::Desk::Person.update(123, last_name: "Updated", email: "john.updated@example.com")

            assert_instance_of Hash, person
            assert_equal 123, person["people"].first["id"]
            assert_equal "Updated", person["people"].first["last_name"]
            assert_equal "john.updated@example.com", person["people"].first["email"]
          end

          # DELETE tests - direct class method
          def test_destroy_person_class_method
            stub_pike13_request(:delete, "https://test.pike13.com/api/v2/desk/people/123", response_body: {})

            result = Pike13::API::V2::Desk::Person.destroy(123)

            # Delete returns empty hash
            assert_empty(result)
          end
        end
      end
    end
  end
end
