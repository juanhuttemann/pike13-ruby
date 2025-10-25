# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class BookingTest < Minitest::Test
          def setup
            @client = default_client
          end

          def test_all_bookings
            # Bookings support listing with Spyke
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/bookings", response_body: {
                                  "bookings" => []
                                })

            bookings = @client.desk.bookings.all.to_a

            assert_instance_of Array, bookings
          end

          def test_find_booking
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/bookings/123", response_body: {
                                  "bookings" => [{ "id" => 123 }]
                                })

            booking = @client.desk.bookings.find(123)

            assert_instance_of Pike13::API::V2::Desk::Booking, booking
            assert_equal 123, booking.id
          end
        end
      end
    end
  end
end
