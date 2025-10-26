# frozen_string_literal: true

require "faraday"
require "multi_json"

module Pike13
  module Middleware
    # Passthrough JSON parser for non-standard Pike13 API responses
    # Used for endpoints that return flat hashes or arrays without resource wrappers
    # (e.g., available_slots/summary returns {"2020-01-17": 1.0, ...})
    class PassthroughJSONParser < Faraday::Middleware
      def on_complete(env)
        json = env.body.is_a?(Hash) ? env.body.deep_symbolize_keys : MultiJson.load(env.body, symbolize_keys: true)

        # For passthrough, just structure it minimally for Spyke
        env.body = {
          data: json[:errors] ? nil : json,
          metadata: {},
          errors: json[:errors] || {}
        }
      end
    end
  end
end
