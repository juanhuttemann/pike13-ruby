# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Front
        class PersonTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_me
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/front/people/me", response_body: {
                                  "people" => [{ "id" => 123, "first_name" => "John" }]
                                })

            person = Pike13::API::V2::Front::Person.me

            assert_instance_of Pike13::API::V2::Front::Person, person
            assert_equal 123, person.id
          end
        end
      end
    end
  end
end
