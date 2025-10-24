# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Account
        class BusinessTest < Minitest::Test
          def setup
            @client = default_client
          end

          def test_all_businesses
            stub_pike13_request(:get, "/account/businesses", response_body: {
                                  "businesses" => [
                                    { "id" => 1, "name" => "Business 1" },
                                    { "id" => 2, "name" => "Business 2" }
                                  ]
                                })

            businesses = @client.account.businesses.all

            assert_instance_of Array, businesses
            assert_equal 2, businesses.size
            assert_instance_of Pike13::API::V2::Account::Business, businesses.first
          end
        end
      end
    end
  end
end
