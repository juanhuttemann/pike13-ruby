# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class LocationTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_all_locations
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/locations", response_body: {
                                  "locations" => [{ "id" => 1, "name" => "Main" }]
                                })

            locations = Pike13::API::V2::Desk::Location.all

            assert_instance_of Hash, locations
            assert_equal 1, locations["locations"].size
            assert_instance_of Hash, locations["locations"].first
          end

          def test_find_location
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/locations/123", response_body: {
                                  "locations" => [{ "id" => 123, "name" => "Main" }]
                                })

            location = Pike13::API::V2::Desk::Location.find(123)

            assert_instance_of Hash, location
            assert_equal 123, location["locations"].first["id"]
          end
        end
      end
    end
  end
end
