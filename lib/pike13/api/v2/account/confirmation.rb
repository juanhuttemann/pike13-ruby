# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Account
        class Confirmation < Base
          uri "account/confirmations(/:id)"

          class << self
            # Send confirmation email
            #
            # @param email [String] Email address
            # @return [Boolean] Success status
            #
            # @example
            #   Pike13::API::V2::Account::Confirmation.create(
            #     email: "user@example.com"
            #   )
            def create(email:)
              connection.post("/api/v2/account/confirmations") do |req|
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
