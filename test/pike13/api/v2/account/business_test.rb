# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Account
        class BusinessTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_all_businesses
            stub_pike13_request(:get, "https://pike13.com/api/v2/account/businesses", response_body: {
                                  "businesses" => [
                                    { "id" => 1, "name" => "Business 1" },
                                    { "id" => 2, "name" => "Business 2" }
                                  ]
                                })

            businesses = Pike13::API::V2::Account::Business.all

            assert_instance_of Hash, businesses
            assert_equal 2, businesses["businesses"].size
            assert_instance_of Hash, businesses["businesses"].first
          end
        end
      end
    end
  end
end
