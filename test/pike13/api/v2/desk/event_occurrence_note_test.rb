# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class EventOccurrenceNoteTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_all
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/event_occurrences/100/notes",
                                response_body: {
                                  "notes" => [{ "id" => 1, "note" => "Test note" }]
                                })

            result = Pike13::API::V2::Desk::EventOccurrenceNote.all(event_occurrence_id: 100)

            assert_instance_of Hash, result
            assert_equal 1, result["notes"].first["id"]
          end

          def test_find
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/event_occurrences/100/notes/1",
                                response_body: {
                                  "notes" => [{ "id" => 1, "note" => "Test note" }]
                                })

            result = Pike13::API::V2::Desk::EventOccurrenceNote.find(event_occurrence_id: 100, id: 1)

            assert_instance_of Hash, result
            assert_equal "Test note", result["notes"].first["note"]
          end

          def test_create
            stub_pike13_request(:post, "https://test.pike13.com/api/v2/desk/event_occurrences/100/notes",
                                response_body: {
                                  "notes" => [{ "id" => 2, "note" => "New note" }]
                                })

            result = Pike13::API::V2::Desk::EventOccurrenceNote.create(event_occurrence_id: 100,
                                                                       attributes: { note: "New note" })

            assert_instance_of Hash, result
            assert_equal 2, result["notes"].first["id"]
          end

          def test_update
            stub_pike13_request(:put, "https://test.pike13.com/api/v2/desk/event_occurrences/100/notes/1",
                                response_body: {
                                  "notes" => [{ "id" => 1, "note" => "Updated note" }]
                                })

            result = Pike13::API::V2::Desk::EventOccurrenceNote.update(event_occurrence_id: 100, id: 1,
                                                                       attributes: { note: "Updated note" })

            assert_instance_of Hash, result
            assert_equal "Updated note", result["notes"].first["note"]
          end

          def test_destroy
            stub_pike13_request(:delete,
                                "https://test.pike13.com/api/v2/desk/event_occurrences/123/notes/456",
                                response_body: {})

            result = Pike13::API::V2::Desk::EventOccurrenceNote.destroy(event_occurrence_id: 123, id: 456)

            assert_instance_of Hash, result
          end
        end
      end
    end
  end
end
