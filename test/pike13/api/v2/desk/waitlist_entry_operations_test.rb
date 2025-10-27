# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class WaitlistEntryOperationsTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_create_waitlist_entry
            stub_pike13_request(:post, "https://test.pike13.com/api/v2/desk/waitlist_entries", response_body: {
                                  "waitlist_entries" => [{ "id" => 123, "state" => "waiting" }]
                                })

            result = Pike13::API::V2::Desk::WaitlistEntry.create({ person_id: 1, event_occurrence_id: 100 })

            assert_instance_of Hash, result
            assert_equal 123, result["waitlist_entries"].first["id"]
          end

          def test_update_waitlist_entry
            stub_pike13_request(:put, "https://test.pike13.com/api/v2/desk/waitlist_entries/123", response_body: {
                                  "waitlist_entries" => [{ "id" => 123, "state" => "enrolled" }]
                                })

            result = Pike13::API::V2::Desk::WaitlistEntry.update(123, { state_event: "enroll" })

            assert_instance_of Hash, result
            assert_equal "enrolled", result["waitlist_entries"].first["state"]
          end

          def test_destroy_waitlist_entry
            stub_pike13_request(:delete, "https://test.pike13.com/api/v2/desk/waitlist_entries/123", response_body: {})

            result = Pike13::API::V2::Desk::WaitlistEntry.destroy(123)

            assert_instance_of Hash, result
          end
        end
      end
    end
  end
end
