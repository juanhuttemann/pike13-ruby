# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Front
        class BusinessTest < Minitest::Test
          def setup
            @client = default_client
          end

          def test_find_business
            stub_pike13_request(:get, "/front/business", response_body: {
                                  "business" => { "id" => 1 }
                                })

            item = Pike13::API::V2::Front::Business.all.first

            assert_equal 1, item.id
          end
        end
      end
    end
  end
end
