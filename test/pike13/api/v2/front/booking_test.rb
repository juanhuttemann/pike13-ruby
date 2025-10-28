# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Front
        class BookingTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_find_booking
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/front/bookings/123", response_body: {
                                  "bookings" => [{ "id" => 123 }]
                                })

            booking = Pike13::API::V2::Front::Booking.find(123)

            assert_instance_of Hash, booking
            assert_equal 123, booking["bookings"].first["id"]
          end

          def test_find_lease
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/front/bookings/123/leases/456", response_body: {
                                  "leases" => [{ "id" => 456, "booking_id" => 123, "status" => "active" }]
                                })

            result = Pike13::API::V2::Front::Booking.find_lease(booking_id: 123, id: 456)

            lease = result["leases"].first

            assert_equal 456, lease["id"]
            assert_equal 123, lease["booking_id"]
            assert_equal "active", lease["status"]
          end

          def test_create_booking
            stub_pike13_request(:post, "https://test.pike13.com/api/v2/front/bookings", response_body: {
                                  "bookings" => [{ "id" => 789, "state" => "reserved" }]
                                })

            result = Pike13::API::V2::Front::Booking.create(
              event_occurrence_id: 100,
              person_id: 200
            )

            assert_instance_of Hash, result
            assert_equal 789, result["bookings"].first["id"]
            assert_equal "reserved", result["bookings"].first["state"]
          end

          def test_update_booking
            stub_pike13_request(:put, "https://test.pike13.com/api/v2/front/bookings/123", response_body: {
                                  "bookings" => [{ "id" => 123, "state" => "completed" }]
                                })

            result = Pike13::API::V2::Front::Booking.update(123, state: "completed")

            assert_instance_of Hash, result
            assert_equal 123, result["bookings"].first["id"]
            assert_equal "completed", result["bookings"].first["state"]
          end

          def test_destroy_lease
            stub_pike13_request(:delete, "https://test.pike13.com/api/v2/front/bookings/123/leases/456",
                                response_body: {})

            result = Pike13::API::V2::Front::Booking.destroy_lease(123, 456)

            assert_instance_of Hash, result
          end
        end
      end
    end
  end
end
