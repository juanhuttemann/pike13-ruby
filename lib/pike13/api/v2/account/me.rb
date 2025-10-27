# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Account
        # Account resource for fetching current account details
        class Me < Base
          class << self
            # GET /account
            # Returns { accounts: [...] }
            def me
              response = client.get("account")
              response.is_a?(Array) ? response.first : response
            end
          end
        end
      end
    end
  end
end
