# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Account
        # Account resource for fetching current account details
        class Base < Spyke::Base
          uri "account"
          include_root_in_json :account

          # Get current account details
          #
          # @return [Pike13::API::V2::Account::Base] Account instance
          #
          # @example
          #   account = Pike13::API::V2::Account::Base.me
          #   puts account.email
          def self.me
            # GET /account returns { accounts: [...] }
            # Spyke will handle the response through Pike13JSONParser
            all.first
          end
        end
      end
    end
  end
end
