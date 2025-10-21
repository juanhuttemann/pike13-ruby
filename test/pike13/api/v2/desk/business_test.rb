# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class BusinessTest < Minitest::Test
          def setup
            @client = default_client
          end

          def test_find_business
            stub_pike13_request(:get, "/desk/business", scope: "desk", response_body: {
                                  "business" => { "id" => 1, "name" => "Test Business" }
                                })

            business = @client.desk.business.find

            assert_instance_of Pike13::API::V2::Desk::Business, business
            assert_equal 1, business.id
            assert_equal "Test Business", business.name
          end
        end
      end
    end
  end
end
