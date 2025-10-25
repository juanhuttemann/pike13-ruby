# frozen_string_literal: true

require "test_helper"

module Pike13
  module API
    module V2
      module Account
        class ConfirmationTest < Minitest::Test
          def setup
            @client = default_client
          end

          def test_create_confirmation
            stub_pike13_request(:post, "https://pike13.com/api/v2/account/confirmations",
                                status: 201,
                                response_body: {})

            result = Pike13::API::V2::Account::Confirmation.create(email: "test@example.com")

            assert result
          end
        end
      end
    end
  end
end
