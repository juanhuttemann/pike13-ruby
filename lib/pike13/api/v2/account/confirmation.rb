# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Account
        class Confirmation < Spyke::Base
          uri "account/confirmations(/:id)"

          class << self
            # Send confirmation email
            #
            # @param client [Pike13::Client] Client instance
            # @param email [String] Email address
            # @return [Boolean] Success status
            #
            # @example
            #   Pike13::API::V2::Account::Confirmation.create(
            #     email: "user@example.com",
            #     client: client
            #   )
            def create(email:, client:)
              response = client.post("/account/confirmations", body: {
                account: { email: email }
              })
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
