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
            stub_pike13_request(:get, "/front/locations", scope: "front", response_body: {
                                  "locations" => [{ "id" => 1, "name" => "Main" }]
                                })

            locations = @client.front.locations.all

            assert_equal 1, locations.size
          end

          def test_find_location
            stub_pike13_request(:get, "/front/locations/123", scope: "front", response_body: {
                                  "locations" => [{ "id" => 123, "name" => "Main" }]
                                })

            location = @client.front.locations.find(123)

            assert_equal 123, location.id
          end
        end
      end
    end
  end
end
