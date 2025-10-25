# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Front
        class NoteTest < Minitest::Test
          def setup
            @client = default_client
          end

          def test_all_notes_for_person
            stub_pike13_request(:get, "/front/people/123/notes", response_body: {
                                  "notes" => [
                                    { "id" => 1, "note" => "First note", "person_id" => 123, "pinned" => true },
                                    { "id" => 2, "note" => "Second note", "person_id" => 123, "pinned" => false }
                                  ]
                                })

            notes = Pike13::API::V2::Front::Note.all(client: @client, person_id: 123)

            assert_instance_of Array, notes
            assert_equal 2, notes.size
            assert_instance_of Pike13::API::V2::Front::Note, notes.first
            assert_equal "First note", notes.first.note
          end

          def test_find_note_for_person
            stub_pike13_request(:get, "/front/people/123/notes/456", response_body: {
                                  "notes" => [
                                    { "id" => 456, "note" => "Important note", "person_id" => 123, "pinned" => true }
                                  ]
                                })

            note = Pike13::API::V2::Front::Note.find(id: 456, client: @client, person_id: 123)

            assert_instance_of Pike13::API::V2::Front::Note, note
            assert_equal 456, note.id
            assert_equal "Important note", note.note
            assert_equal true, note.pinned
          end
        end
      end
    end
  end
end
