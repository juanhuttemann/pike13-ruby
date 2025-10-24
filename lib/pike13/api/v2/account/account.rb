# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Account
        class Account < Pike13::API::V2::SingularResource
          @resource_name = "account"

          # Get current account
          # Custom implementation since account endpoint has different path structure
          #
          # @param client [Pike13::Client] Client client
          # @return [Pike13::API::V2::Account::Account]
          #
          # @example
          #   account = Pike13::API::V2::Account::Account.me(client: client)
          def self.me(client:)
            path = "/account"
            response = client.get(path)

            data = response["accounts"]&.first || {}
            new(client: client, **data.transform_keys(&:to_sym))
          end
        end
      end
    end
  end
end
