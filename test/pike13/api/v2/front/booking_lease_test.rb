# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Front
        class BookingLeaseTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_create_lease
            stub_pike13_request(:post, "https://test.pike13.com/api/v2/front/bookings/123/leases", response_body: {
                                  "leases" => [{ "id" => 456 }]
                                })

            lease = Pike13::API::V2::Front::Booking.create_lease(123, { event_occurrence_id: 1000 })

            assert_instance_of Hash, lease
            assert_equal 456, lease["leases"].first["id"]
          end

          def test_update_lease
            stub_pike13_request(:put, "https://test.pike13.com/api/v2/front/bookings/123/leases/456", response_body: {
                                  "leases" => [{ "id" => 456 }]
                                })

            lease = Pike13::API::V2::Front::Booking.update_lease(123, 456, { person: { id: 1 } })

            assert_instance_of Hash, lease
            assert_equal 456, lease["leases"].first["id"]
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
