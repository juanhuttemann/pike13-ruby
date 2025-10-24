# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Front
        class EventTest < Minitest::Test
          def setup
            @client = default_client
          end

          def test_all_events
            stub_pike13_request(:get, "/front/events", response_body: {
                                  "events" => [{ "id" => 1 }]
                                })

            events = @client.front.events.all

            assert_equal 1, events.size
          end

          def test_find_event
            stub_pike13_request(:get, "/front/events/123", response_body: {
                                  "events" => [{ "id" => 123 }]
                                })

            event = @client.front.events.find(123)

            assert_equal 123, event.id
          end
        end
      end
    end
  end
end
