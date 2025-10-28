# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class NoteTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_create_note
            stub_pike13_request(:post, "https://test.pike13.com/api/v2/desk/people/123/notes",
                                response_body: {
                                  "notes" => [{ "id" => 456, "note" => "Test note" }]
                                })

            result = Pike13::API::V2::Desk::Note.create(person_id: 123, attributes: { note: "Test note" })

            assert_instance_of Hash, result
            assert_equal 456, result["notes"].first["id"]
            assert_equal "Test note", result["notes"].first["note"]
          end

          def test_update_note
            stub_pike13_request(:put, "https://test.pike13.com/api/v2/desk/people/123/notes/456",
                                response_body: {
                                  "notes" => [{ "id" => 456, "note" => "Updated note" }]
                                })

            result = Pike13::API::V2::Desk::Note.update(person_id: 123, id: 456, attributes: { note: "Updated note" })

            assert_instance_of Hash, result
            assert_equal 456, result["notes"].first["id"]
            assert_equal "Updated note", result["notes"].first["note"]
          end

          def test_destroy_note
            stub_pike13_request(:delete, "https://test.pike13.com/api/v2/desk/people/123/notes/456",
                                response_body: {})

            result = Pike13::API::V2::Desk::Note.destroy(person_id: 123, id: 456)

            assert_instance_of Hash, result
          end
        end
      end
    end
  end
end
