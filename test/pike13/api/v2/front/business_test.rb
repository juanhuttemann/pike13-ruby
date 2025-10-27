# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Front
        class BusinessTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_find_business
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/front/business", response_body: {
                                  "business" => { "id" => 1 }
                                })

            result = Pike13::API::V2::Front::Business.get

            assert_equal 1, result["business"]["id"]
          end
        end
      end
    end
  end
end
