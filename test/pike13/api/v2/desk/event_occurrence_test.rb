# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class EventOccurrenceTest < Minitest::Test
          def setup
            @client = default_client
          end

          def test_all_event_occurrences
            stub_pike13_request(:get, "/desk/event_occurrences", scope: "desk", response_body: {
                                  "event_occurrences" => [{ "id" => 1 }]
                                })

            items = @client.desk.event_occurrences.all

            assert_equal 1, items.size
          end

          def test_find_event_occurrence
            stub_pike13_request(:get, "/desk/event_occurrences/123", scope: "desk", response_body: {
                                  "event_occurrences" => [{ "id" => 123 }]
                                })

            item = @client.desk.event_occurrences.find(123)

            assert_equal 123, item.id
          end

          def test_summary
            stub_pike13_request(:get, "/desk/event_occurrences/summary", scope: "desk", response_body: {
                                  "event_occurrence_summaries" => [
                                    { "event_id" => 1, "name" => "Yoga", "total_occurrences" => 10 },
                                    { "event_id" => 2, "name" => "Pilates", "total_occurrences" => 5 }
                                  ]
                                })

            summaries = @client.desk.event_occurrences.summary

            assert_equal 2, summaries.size
            assert_equal 1, summaries.first["event_id"]
            assert_equal "Yoga", summaries.first["name"]
          end

          def test_enrollment_eligibilities
            stub_pike13_request(:get, "/desk/event_occurrences/123/enrollment_eligibilities",
                                scope: "desk",

                                response_body: {
                                  "enrollment_eligibilities" => [
                                    { "person_id" => 1,
                                      "eligible" => true, "reasons" => [] },
                                    { "person_id" => 2,
                                      "eligible" => false, "reasons" => ["Waitlist full"] }
                                  ]
                                })

            eligibilities = @client.desk.event_occurrences.enrollment_eligibilities(id: 123)

            assert_equal 2, eligibilities.size
            assert eligibilities.first["eligible"]
            refute eligibilities.last["eligible"]
          end
        end
      end
    end
  end
end
