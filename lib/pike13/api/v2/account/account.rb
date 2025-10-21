# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Account
        class Account < Pike13::API::V2::SingularResource
          @scope = "account"
          @resource_name = "account"

          # Get current account
          # Custom implementation since account endpoint has different path structure
          #
          # @param session [Pike13::Client] Client session
          # @return [Pike13::API::V2::Account::Account]
          #
          # @example
          #   account = Pike13::API::V2::Account::Account.me(session: client)
          def self.me(session:)
            path = "/account"
            response = session.http_client.get(path, scoped: false)

            data = response["accounts"]&.first || {}
            new(session: session, **data.transform_keys(&:to_sym))
          end
        end
      end
    end
  end
end
