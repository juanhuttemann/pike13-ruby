# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        # Base class for all Desk namespace models
        # Desk endpoints use the business subdomain (scoped connection)
        class Base < Spyke::Base
          extend Pike13::ConnectionBuilder

          def self.configure(config)
            self.connection = build_connection(config.full_url, config.access_token)
          end
        end
      end
    end
  end
end
