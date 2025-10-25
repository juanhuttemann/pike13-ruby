# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Front
        class EventOccurrenceTest < Minitest::Test
          def setup
            @client = default_client
          end

          def test_all_event_occurrences
            stub_pike13_request(:get, "/front/event_occurrences", response_body: {
                                  "event_occurrences" => [{ "id" => 1 }]
                                })

            event_occurrences = @client.front.event_occurrences.all.to_a

            assert_instance_of Array, event_occurrences
            assert_equal 1, event_occurrences.size
            assert_instance_of Pike13::API::V2::Front::EventOccurrence, event_occurrences.first
          end

          def test_find_event_occurrence
            stub_pike13_request(:get, "/front/event_occurrences/123", response_body: {
                                  "event_occurrences" => [{ "id" => 123 }]
                                })

            event_occurrence = @client.front.event_occurrences.find(123)

            assert_instance_of Pike13::API::V2::Front::EventOccurrence, event_occurrence
            assert_equal 123, event_occurrence.id
          end

          def test_summary
            stub_pike13_request(:get, "/front/event_occurrences/summary", response_body: {
                                  "event_occurrence_summaries" => [
                                    { "event_id" => 1, "name" => "Yoga", "total_occurrences" => 10 },
                                    { "event_id" => 2, "name" => "Pilates", "total_occurrences" => 5 }
                                  ]
                                })

            summaries = @client.front.event_occurrences.summary

            assert_equal 2, summaries.size
            assert_equal 1, summaries.first["event_id"]
            assert_equal "Yoga", summaries.first["name"]
          end

          def test_enrollment_eligibilities
            stub_pike13_request(:get, "/front/event_occurrences/123/enrollment_eligibilities",
                                response_body: {
                                  "enrollment_eligibilities" => [
                                    { "person_id" => 1,
                                      "eligible" => true, "reasons" => [] },
                                    { "person_id" => 2,
                                      "eligible" => false, "reasons" => ["Waitlist full"] }
                                  ]
                                })

            eligibilities = @client.front.event_occurrences.enrollment_eligibilities(id: 123)

            assert_equal 2, eligibilities.size
            assert eligibilities.first["eligible"]
            refute eligibilities.last["eligible"]
          end
        end
      end
    end
  end
end
