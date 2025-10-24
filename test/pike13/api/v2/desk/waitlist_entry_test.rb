# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class WaitlistEntryTest < Minitest::Test
          def setup
            @client = default_client
          end

          def test_find_waitlist_entry
            stub_pike13_request(:get, "/desk/waitlist_entries/123", response_body: {
                                  "waitlist_entries" => [{ "id" => 123 }]
                                })

            entry = @client.desk.waitlist_entries.find(123)

            assert_equal 123, entry.id
          end
        end
      end
    end
  end
end
