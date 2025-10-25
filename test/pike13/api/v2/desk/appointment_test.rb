# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class AppointmentTest < Minitest::Test
          def setup
            @client = default_client
          end

          def test_find_available_slots
            stub_pike13_request(:get, "/desk/appointments/123/available_slots", response_body: {
                                  "available_slots" => [
                                    { "start_time" => "2024-01-15T10:00:00Z", "end_time" => "2024-01-15T11:00:00Z" },
                                    { "start_time" => "2024-01-15T11:00:00Z", "end_time" => "2024-01-15T12:00:00Z" }
                                  ]
                                })

            slots = Pike13::API::V2::Desk::Appointment.find_available_slots(service_id: 123)

            assert_equal 2, slots.size
            assert_equal "2024-01-15T10:00:00Z", slots.first["start_time"]
          end

          def test_available_slots_summary
            stub_pike13_request(:get, "/desk/appointments/123/available_slots/summary", response_body: {
                                  "2020-01-17" => 1.0,
                                  "2020-01-18" => 0,
                                  "2020-01-19" => 0.5
                                })

            summary = Pike13::API::V2::Desk::Appointment.available_slots_summary(service_id: 123)

            assert_in_delta 1.0, summary["2020-01-17"]
            assert_in_delta 0, summary["2020-01-18"]
            assert_in_delta 0.5, summary["2020-01-19"]
          end

          def test_available_slots_summary_with_range_error
            base_url = "https://test.pike13.com/api/v2"
            full_url = "#{base_url}/desk/appointments/123/available_slots/summary?from=2020-01-20&to=2021-01-20"

            stub_request(:get, full_url)
              .with(headers: { "Authorization" => "Bearer test_token" })
              .to_return(
                status: 200,
                body: { "errors" => ["Range exceeds allowed limit (90 days)"] }.to_json,
                headers: { "Content-Type" => "application/json" }
              )

            error = assert_raises(Pike13::ValidationError) do
              Pike13::API::V2::Desk::Appointment.available_slots_summary(
                service_id: 123,
                from: "2020-01-20",
                to: "2021-01-20"
              )
            end

            assert_equal "Range exceeds allowed limit (90 days)", error.message
            assert_equal 422, error.http_status
          end
        end
      end
    end
  end
end
