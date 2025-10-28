# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Front
        class WaitlistEntryTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_find_waitlist_entry
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/front/waitlist_entries/123", response_body: {
                                  "waitlist_entries" => [{ "id" => 123 }]
                                })

            waitlist_entry = Pike13::API::V2::Front::WaitlistEntry.find(123)

            assert_instance_of Hash, waitlist_entry
            assert_equal 123, waitlist_entry["waitlist_entries"].first["id"]
          end

          def test_create_waitlist_entry
            stub_pike13_request(:post, "https://test.pike13.com/api/v2/front/waitlist_entries",
                                response_body: {
                                  "waitlist_entries" => [
                                    { "id" => 456, "person_id" => 123, "event_occurrence_id" => 789 }
                                  ]
                                })

            result = Pike13::API::V2::Front::WaitlistEntry.create(
              person_id: 123,
              event_occurrence_id: 789
            )

            assert_instance_of Hash, result
            assert_equal 456, result["waitlist_entries"].first["id"]
            assert_equal 123, result["waitlist_entries"].first["person_id"]
          end

          def test_destroy_waitlist_entry
            stub_pike13_request(:delete, "https://test.pike13.com/api/v2/front/waitlist_entries/456",
                                response_body: {})

            result = Pike13::API::V2::Front::WaitlistEntry.destroy(456)

            assert_instance_of Hash, result
          end
        end
      end
    end
  end
end
