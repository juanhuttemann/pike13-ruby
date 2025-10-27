# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class VisitTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_find_visit
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/visits/123", response_body: {
                                  "visits" => [{ "id" => 123, "state" => "completed" }]
                                })

            visit = Pike13::API::V2::Desk::Visit.find(123)

            assert_instance_of Hash, visit
            assert_equal 123, visit["visits"].first["id"]
          end

          def test_summary
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/people/123/visits/summary", response_body: {
                                  "visit_summary" => {
                                    "first_visit_at" => "2020-01-01T00:00:00Z",
                                    "last_visit_at" => "2025-10-21T00:00:00Z",
                                    "total_visits" => 100
                                  }
                                })

            summary = Pike13::API::V2::Desk::Visit.summary(person_id: 123)

            assert_equal({
                           "visit_summary" => {
                             "first_visit_at" => "2020-01-01T00:00:00Z",
                             "last_visit_at" => "2025-10-21T00:00:00Z",
                             "total_visits" => 100
                           }
                         }, summary)
          end

          def test_create_visit
            stub_pike13_request(:post, "https://test.pike13.com/api/v2/desk/visits", response_body: {
                                  "visits" => [{ "id" => 123, "state" => "registered" }]
                                })

            visit = Pike13::API::V2::Desk::Visit.create({ person_id: 1, event_occurrence_id: 100 })

            assert_instance_of Hash, visit
            assert_equal 123, visit["visits"].first["id"]
          end

          def test_update_visit
            stub_pike13_request(:put, "https://test.pike13.com/api/v2/desk/visits/123", response_body: {
                                  "visits" => [{ "id" => 123, "state" => "completed" }]
                                })

            visit = Pike13::API::V2::Desk::Visit.update(123, { state_event: "complete" })

            assert_instance_of Hash, visit
            assert_equal "completed", visit["visits"].first["state"]
          end

          def test_destroy_visit
            stub_pike13_request(:delete, "https://test.pike13.com/api/v2/desk/visits/123", response_body: {})

            result = Pike13::API::V2::Desk::Visit.destroy(123)

            assert_instance_of Hash, result
          end
        end
      end
    end
  end
end
