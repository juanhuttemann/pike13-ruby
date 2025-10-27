# frozen_string_literal: true

module Pike13
  module API
    module V2
      module Desk
        # Base class for all Desk namespace resources
        # Desk endpoints use the business subdomain (scoped connection)
        class Base
          class << self
            def configure(config)
              @client = Pike13::HTTPClient.new(
                base_url: config.full_url,
                access_token: config.access_token
              )
            end

            def client
              # Return this class's client if set, otherwise traverse up to Base
              return @client if instance_variable_defined?(:@client) && @client
              return superclass.client if superclass.respond_to?(:client) && superclass != Object

              raise "Client not configured. Call Pike13.configure first."
            end
          end
        end
      end
    end
  end
end
