# frozen_string_literal: true

module Pike13
  module API
    module V3
      module Desk
        # Base class for all V3 Desk reporting resources
        # V3 Reporting API uses POST requests to /desk/api/v3/reports/{resource}/queries
        class Base
          class << self
            def configure(config)
              @client = Pike13::HTTPClientV3.new(
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

            # Execute a reporting query
            #
            # @param resource [String] The resource name (e.g., 'monthly_business_metrics')
            # @param query_params [Hash] Query parameters including fields, filters, etc.
            # @return [Hash] Query result with rows, fields, and metadata
            def query(resource, query_params)
              data = {
                data: {
                  type: "queries",
                  attributes: query_params
                }
              }

              client.post("desk/api/v3/reports/#{resource}/queries", data)
            end
          end
        end
      end
    end
  end
end
