# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      class AccountTest < Minitest::Test
        def setup
          @client = default_client
        end

        def test_me
          stub_pike13_request(:get, "https://pike13.com/api/v2/account", response_body: {
                                "accounts" => [
                                  {
                                    "id" => 999,
                                    "email" => "user@example.com",
                                    "first_name" => "John",
                                    "last_name" => "Doe"
                                  }
                                ]
                              })

          account = Pike13::API::V2::Account::Base.me

          assert_instance_of Pike13::API::V2::Account::Base, account
          assert_equal 999, account.id
          assert_equal "user@example.com", account.email
          assert_equal "John", account.first_name
          assert_equal "Doe", account.last_name
        end
      end
    end
  end
end
