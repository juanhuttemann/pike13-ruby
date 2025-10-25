# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class NoteTest < Minitest::Test
          def setup
            @client = default_client
          end

          # READ tests
          def test_all_notes_for_person
            stub_pike13_request(:get, "/desk/people/123/notes", response_body: {
                                  "notes" => [
                                    { "id" => 1, "note" => "First note", "person_id" => 123 },
                                    { "id" => 2, "note" => "Second note", "person_id" => 123 }
                                  ]
                                })

            notes = Pike13::API::V2::Desk::Note.where(person_id: 123).all.to_a

            assert_instance_of Array, notes
            assert_equal 2, notes.size
            assert_instance_of Pike13::API::V2::Desk::Note, notes.first
            assert_equal "First note", notes.first.note
          end

          def test_find_note_for_person
            stub_pike13_request(:get, "/desk/people/123/notes/456", response_body: {
                                  "notes" => [
                                    { "id" => 456, "note" => "Important note", "person_id" => 123, "pinned" => true }
                                  ]
                                })

            note = Pike13::API::V2::Desk::Note.where(person_id: 123).find(456)

            assert_instance_of Pike13::API::V2::Desk::Note, note
            assert_equal 456, note.id
            assert_equal "Important note", note.note
            assert_equal true, note.pinned
          end

          # CREATE tests
          def test_create_note_for_person
            stub_pike13_request(:post, "/desk/people/123/notes", response_body: {
                                  "notes" => [
                                    {
                                      "id" => 789,
                                      "note" => "New note",
                                      "public" => false,
                                      "pinned" => true,
                                      "person_id" => 123
                                    }
                                  ]
                                })

            note = Pike13::API::V2::Desk::Note.where(person_id: 123).create(
              note: "New note",
              pinned: true
            )

            assert_instance_of Pike13::API::V2::Desk::Note, note
            assert_equal 789, note.id
            assert_equal "New note", note.note
            assert_equal true, note.pinned
            assert_equal 123, note.person_id
          end

          # UPDATE tests - via class method
          def test_update_note_via_class_method
            stub_pike13_request(:get, "/desk/people/123/notes/456", response_body: {
                                  "notes" => [
                                    {
                                      "id" => 456,
                                      "note" => "Original text",
                                      "person_id" => 123,
                                      "pinned" => true
                                    }
                                  ]
                                })
            stub_pike13_request(:put, "/desk/people/123/notes/456", response_body: {
                                  "notes" => [
                                    {
                                      "id" => 456,
                                      "note" => "Updated note text",
                                      "person_id" => 123,
                                      "pinned" => false
                                    }
                                  ]
                                })

            note = Pike13::API::V2::Desk::Note.where(person_id: 123).find(456)
            note.update_attributes(
              note: "Updated note text",
              pinned: false
            )

            assert_instance_of Pike13::API::V2::Desk::Note, note
            assert_equal 456, note.id
            assert_equal "Updated note text", note.note
            assert_equal false, note.pinned
          end

          # UPDATE tests - via instance (2 requests: find + update)
          def test_update_note_via_instance
            # First request: find
            stub_pike13_request(:get, "/desk/people/123/notes/456", response_body: {
                                  "notes" => [
                                    { "id" => 456, "note" => "Original text", "person_id" => 123, "pinned" => false }
                                  ]
                                })

            note = Pike13::API::V2::Desk::Note.where(person_id: 123).find(456)

            assert_equal "Original text", note.note

            # Second request: update
            stub_pike13_request(:put, "/desk/people/123/notes/456", response_body: {
                                  "notes" => [
                                    { "id" => 456, "note" => "Updated text", "person_id" => 123, "pinned" => true }
                                  ]
                                })

            note.update_attributes(note: "Updated text", pinned: true)

            assert_equal "Updated text", note.note
            assert_equal true, note.pinned
          end

          # DELETE tests - via class method
          def test_destroy_note_via_class_method
            stub_pike13_request(:get, "/desk/people/123/notes/456", response_body: {
                                  "notes" => [
                                    { "id" => 456, "note" => "Note to delete", "person_id" => 123 }
                                  ]
                                })
            delete_endpoint = stub_pike13_request(:delete, "/desk/people/123/notes/456", response_body: {})

            note = Pike13::API::V2::Desk::Note.where(person_id: 123).find(456)
            note.destroy

            assert delete_endpoint
          end

          # DELETE tests - via instance (2 requests: find + delete)
          def test_destroy_note_via_instance
            # First request: find
            stub_pike13_request(:get, "/desk/people/123/notes/456", response_body: {
                                  "notes" => [
                                    { "id" => 456, "note" => "Note to delete", "person_id" => 123 }
                                  ]
                                })

            note = Pike13::API::V2::Desk::Note.where(person_id: 123).find(456)

            assert_equal 456, note.id

            # Second request: delete
            stub_pike13_request(:delete, "/desk/people/123/notes/456", response_body: {})

            note.destroy

            assert_predicate note, :destroyed?
          end

          # EVENT_OCCURRENCE tests
        end
      end
    end
  end
end
