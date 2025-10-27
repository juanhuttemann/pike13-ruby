# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class BookingTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_find_booking
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/bookings/123", response_body: {
                                  "bookings" => [{ "id" => 123 }]
                                })

            booking = Pike13::API::V2::Desk::Booking.find(123)

            assert_instance_of Hash, booking
            assert_equal 123, booking["bookings"].first["id"]
          end
        end
      end
    end
  end
end
