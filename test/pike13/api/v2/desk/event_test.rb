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

            items = @client.desk.events.all.to_a

            assert_equal 1, items.size
            assert_instance_of Pike13::API::V2::Desk::Event, items.first
          end

          def test_find_event
            stub_pike13_request(:get, "/desk/events/123", response_body: {
                                  "events" => [{ "id" => 123 }]
                                })

            item = @client.desk.events.find(123)

            assert_equal 123, item.id
            assert_instance_of Pike13::API::V2::Desk::Event, item
          end
        end
      end
    end
  end
end
