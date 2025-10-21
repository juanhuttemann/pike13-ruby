# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Front
        class VisitTest < Minitest::Test
          def setup
            @client = default_client
          end

          def test_find_visit
            stub_pike13_request(:get, "/front/visits/123", scope: "front", response_body: {
                                  "visits" => [{ "id" => 123 }]
                                })

            visit = @client.front.visits.find(123)

            assert_equal 123, visit.id
          end
        end
      end
    end
  end
end
