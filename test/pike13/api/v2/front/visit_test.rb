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
        end
      end
    end
  end
end
