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

            assert_instance_of Pike13::API::V2::Front::WaitlistEntry, waitlist_entry
            assert_equal 123, waitlist_entry.id
          end
        end
      end
    end
  end
end
