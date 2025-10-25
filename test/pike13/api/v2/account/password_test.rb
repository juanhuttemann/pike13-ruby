# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Account
        class PasswordTest < Minitest::Test
          def setup
            @client = default_client
          end

          def test_create_password_reset
            stub_pike13_request(:post, "/account/passwords",
                                status: 201,
                                response_body: {})

            result = @client.account.passwords.create(email: "test@example.com", client: @client)

            assert result
          end
        end
      end
    end
  end
end
