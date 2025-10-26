# frozen_string_literal: true

require "faraday"
require "multi_json"

module Pike13
  module Middleware
    # Standard JSON parser for Pike13 API CRUD responses
    # Handles typical responses like: {"people": [...], "total_count": 10}
    # Transforms to Spyke format: { data: {...} or [{...}], metadata: {...}, errors: {} }
    class JSONParser < Faraday::Middleware
      METADATA_KEYS = %i[total_count page per_page].freeze

      def on_complete(env)
        json = env.body.is_a?(Hash) ? env.body.deep_symbolize_keys : MultiJson.load(env.body, symbolize_keys: true)

        # Find the resource key (not errors or pagination metadata)
        resource_key = json.keys.find { |k| !METADATA_KEYS.include?(k) && k != :errors }
        resource_data = json[resource_key]

        # Spyke expects:
        # - Single hash for .find(id), .create, .update
        # - Array for .all, .where, etc.
        data = unwrap_if_needed(resource_data, env)

        env.body = {
          data: data,
          metadata: json.slice(*METADATA_KEYS),
          errors: json[:errors] || {}
        }
      end

      private

      def unwrap_if_needed(resource_data, env)
        path = env.url.path
        method = env.method
        is_single_resource = path.match?(%r{/(\d+|me)$}) || %i[post put].include?(method)

        case resource_data
        when Array
          # Unwrap single-element arrays for single-resource requests
          resource_data.size == 1 && is_single_resource ? resource_data.first : resource_data
        when Hash
          # Singleton hash: wrap in array for collection requests, keep as-is for single resource
          is_single_resource ? resource_data : [resource_data]
        else
          resource_data
        end
      end
    end
  end
end
