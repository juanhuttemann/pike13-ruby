# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Desk
        class BusinessTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_find_business
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/business", response_body: {
                                  "business" => { "id" => 1, "name" => "Test Business" }
                                })

            business = Pike13::API::V2::Desk::Business.get

            assert_instance_of Hash, business
            assert_equal 1, business["business"]["id"]
            assert_equal "Test Business", business["business"]["name"]
          end

          def test_franchisees
            stub_pike13_request(:get, "https://test.pike13.com/api/v2/desk/business/franchisees", response_body: {
                                  "franchisees" => [{ "id" => 1, "name" => "Franchisee 1" }]
                                })

            franchisees = Pike13::API::V2::Desk::Business.franchisees

            assert_instance_of Hash, franchisees
            assert_equal 1, franchisees["franchisees"].first["id"]
          end
        end
      end
    end
  end
end
