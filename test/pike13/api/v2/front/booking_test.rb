# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Front
        class BookingTest < Minitest::Test
          def setup
            @client = default_client
          end

          def test_find_booking
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/front/bookings/123", response_body: {
                                  "bookings" => [{ "id" => 123 }]
                                })

            booking = Pike13::API::V2::Front::Booking.find(123)

            assert_instance_of Pike13::API::V2::Front::Booking, booking
            assert_equal 123, booking.id
          end

          def test_find_lease
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/front/bookings/123/leases/456", response_body: {
                                  "leases" => [{ "id" => 456, "booking_id" => 123, "status" => "active" }]
                                })

            lease = Pike13::API::V2::Front::Booking.find_lease(booking_id: 123, id: 456)

            assert_equal 456, lease["id"]
            assert_equal 123, lease["booking_id"]
            assert_equal "active", lease["status"]
          end
        end
      end
    end
  end
end
