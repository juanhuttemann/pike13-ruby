# frozen_string_literal: true

module Pike13
  module API
    module V2
      # Account-level API resources and methods
      module Account
        # Get current account details
        #
        # @param client [Pike13::Client] Client instance
        # @return [Hash] Account data
        #
        # @example
        #   account = Pike13::API::V2::Account.me(client: client)
        #   puts account[:email]
        def self.me(client:)
          raise ArgumentError, "client is required" unless client

          response = client.get("/account")
          response["accounts"]&.first || {}
        end
      end
    end
  end
end
