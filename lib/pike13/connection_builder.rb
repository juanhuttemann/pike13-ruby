# frozen_string_literal: true

require "faraday"
require "faraday/retry"

module Pike13
  # Shared module for building Faraday connections
  # Used by all Base classes (Desk, Front, Account)
  module ConnectionBuilder
    def build_connection(base_url, token)
      Faraday.new(url: "#{base_url}/api/v2") do |c|
        c.request :retry,
                  max: 2,
                  interval: 0.5,
                  backoff_factor: 2
        c.request :json
        c.use Pike13::Middleware::JSONParser
        c.response :json, content_type: /\bjson$/
        c.headers["Authorization"] = "Bearer #{token}"
        c.adapter Faraday.default_adapter
      end
    end
  end
end
