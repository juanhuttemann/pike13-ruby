# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class EventTest < Minitest::Test
          def setup
            @client = default_client
          end

          def test_all_events
            stub_pike13_request(:get, "/desk/events", response_body: {
                                  "events" => [{ "id" => 1 }]
                                })

            items = @client.desk.events.all

            assert_equal 1, items.size
          end

          def test_find_event
            stub_pike13_request(:get, "/desk/events/123", response_body: {
                                  "events" => [{ "id" => 123 }]
                                })

            item = @client.desk.events.find(123)

            assert_equal 123, item.id
          end
        end
      end
    end
  end
end
