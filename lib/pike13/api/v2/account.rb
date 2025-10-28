# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Account
        # Get current authenticated account
        #
        # @return [Hash] Account information
        # @example
        #   account = Pike13::Account.me
        #   email = account["accounts"].first["email"]
        def self.me
          Base.client.get("account")
        end
      end
    end
  end
end
