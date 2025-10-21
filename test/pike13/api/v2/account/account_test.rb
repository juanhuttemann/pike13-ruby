# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Account
        class AccountTest < Minitest::Test
          def setup
            @client = default_client
          end

          def test_me
            stub_pike13_request(:get, "/account", scope: "account", response_body: {
                                  "accounts" => [
                                    {
                                      "id" => 999,
                                      "email" => "user@example.com",
                                      "first_name" => "John",
                                      "last_name" => "Doe"
                                    }
                                  ]
                                })

            account = @client.account.me

            assert_instance_of Pike13::API::V2::Account::Account, account
            assert_equal 999, account.id
            assert_equal "user@example.com", account.email
          end
        end
      end
    end
  end
end
