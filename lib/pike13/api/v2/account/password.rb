# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Account
        class Password < Base
          uri "account/passwords(/:id)"

          class << self
            # Send password reset email
            #
            # @param email [String] Email address
            # @return [Boolean] Success status
            #
            # @example
            #   Pike13::API::V2::Account::Password.create(
            #     email: "user@example.com"
            #   )
            def create(email:)
              connection.post("/api/v2/account/passwords") do |req|
                req.body = { account: { email: email } }.to_json
              end
              true
            rescue StandardError
              false
            end
          end
        end
      end
    end
  end
end
