# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Account
        # Base class for all Account namespace models
        # Account endpoints use pike13.com (unscoped connection)
        class Base < Spyke::Base
          extend Pike13::ConnectionBuilder

          def self.configure(config)
            # Account always uses pike13.com, not the business subdomain
            self.connection = build_connection("https://pike13.com", config.access_token)
          end
        end
      end
    end
  end
end
