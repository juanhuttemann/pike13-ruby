# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Front
        class EventTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_all_events
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/front/events", response_body: {
                                  "events" => [{ "id" => 1 }]
                                })

            events = Pike13::API::V2::Front::Event.all.to_a

            assert_instance_of Array, events
            assert_equal 1, events.size
            assert_instance_of Pike13::API::V2::Front::Event, events.first
          end

          def test_find_event
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/front/events/123", response_body: {
                                  "events" => [{ "id" => 123 }]
                                })

            event = Pike13::API::V2::Front::Event.find(123)

            assert_instance_of Pike13::API::V2::Front::Event, event
            assert_equal 123, event.id
          end
        end
      end
    end
  end
end
