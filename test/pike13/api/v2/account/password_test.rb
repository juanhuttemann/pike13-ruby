# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Account
        class PasswordTest < Minitest::Test
          def setup
            setup_pike13
          end

          def test_create_password_reset
            stub_pike13_request(:post, "https://pike13.com/api/v2/account/passwords",
                                status: 201,
                                response_body: {})

            result = Pike13::API::V2::Account::Password.create(email: "test@example.com")

            assert result
          end
        end
      end
    end
  end
end
