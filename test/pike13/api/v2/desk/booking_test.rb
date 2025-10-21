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
            # Bookings don't support listing - should raise NotImplementedError
            assert_raises(NotImplementedError) do
              @client.desk.bookings.all
            end
          end

          def test_find_booking
            stub_pike13_request(:get, "/desk/bookings/123", scope: "desk", response_body: {
                                  "bookings" => [{ "id" => 123 }]
                                })

            item = @client.desk.bookings.find(123)

            assert_equal 123, item.id
          end
        end
      end
    end
  end
end
