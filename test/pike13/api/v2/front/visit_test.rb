# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Front
        class VisitTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_find_visit
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/front/visits/123", response_body: {
                                  "visits" => [{ "id" => 123 }]
                                })

            visit = Pike13::API::V2::Front::Visit.find(123)

            assert_instance_of Hash, visit
            assert_equal 123, visit["visits"].first["id"]
          end

          def test_create_visit
            stub_pike13_request(:post, "https://test.pike13.com/api/v2/front/visits",
                                response_body: {
                                  "visits" => [{ "id" => 456, "person_id" => 123, "event_occurrence_id" => 789 }]
                                })

            result = Pike13::API::V2::Front::Visit.create(
              person_id: 123,
              event_occurrence_id: 789
            )

            assert_instance_of Hash, result
            assert_equal 456, result["visits"].first["id"]
            assert_equal 123, result["visits"].first["person_id"]
          end

          def test_destroy_visit
            stub_pike13_request(:delete, "https://test.pike13.com/api/v2/front/visits/456",
                                response_body: {})

            result = Pike13::API::V2::Front::Visit.destroy(456)

            assert_instance_of Hash, result
          end
        end
      end
    end
  end
end
