# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      class AccountTest < Minitest::Test
        def setup
          setup_pike13
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

          account = Pike13::Account.me

          assert_instance_of Hash, account
          assert_equal 999, account["accounts"].first["id"]
          assert_equal "user@example.com", account["accounts"].first["email"]
        end
      end
    end
  end
end
