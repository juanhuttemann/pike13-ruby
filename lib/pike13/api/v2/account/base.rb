# frozen_string_literal: true

require "faraday"
require "faraday/retry"

module Pike13
  module API
    module V2
      module Account
        # Base class for all Account namespace models
        # Account endpoints use pike13.com (unscoped connection)
        class Base < Spyke::Base
          UNSCOPED_BASE_URL = "https://pike13.com"

          def self.configure(config)
            self.connection = build_connection(config)
          end

          def self.build_connection(config)
            Faraday.new(url: "#{UNSCOPED_BASE_URL}#{config.api_version}") do |c|
              c.request :retry,
                        max: 2,
                        interval: 0.5,
                        backoff_factor: 2
              c.request :json
              c.use Pike13::Middleware::JSONParser
              c.response :json, content_type: /\bjson$/
              c.headers["Authorization"] = "Bearer #{config.access_token}"
              c.adapter Faraday.default_adapter
            end
          end
        end
      end
    end
  end
end
