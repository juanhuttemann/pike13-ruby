# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Front
        class LocationTest < Minitest::Test
          def setup
            @client = default_client
          end

          def test_all_locations
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/front/locations", response_body: {
                                  "locations" => [{ "id" => 1, "name" => "Main" }]
                                })

            locations = @client.front.locations.all.to_a

            assert_instance_of Array, locations
            assert_equal 1, locations.size
            assert_instance_of Pike13::API::V2::Front::Location, locations.first
          end

          def test_find_location
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/front/locations/123", response_body: {
                                  "locations" => [{ "id" => 123, "name" => "Main" }]
                                })

            location = @client.front.locations.find(123)

            assert_instance_of Pike13::API::V2::Front::Location, location
            assert_equal 123, location.id
          end
        end
      end
    end
  end
end
