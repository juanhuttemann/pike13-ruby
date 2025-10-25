# frozen_string_literal: true

require "faraday"
require "faraday/retry"
require "json"
require "spyke"
require "multi_json"

module Pike13
  # Custom JSON parser for Pike13 API responses
  # Transforms Pike13 response format to Spyke's expected format:
  # { data: {...} or [{...}], metadata: {...}, errors: {} }
  class Pike13JSONParser < Faraday::Middleware
    def on_complete(env)
      # Handle both parsed and unparsed JSON
      json = env.body.is_a?(Hash) ? env.body.deep_symbolize_keys : MultiJson.load(env.body, symbolize_keys: true)

      # Extract the first key as the resource name (e.g., :people, :events)
      resource_key = json.keys.find { |k| k != :total_count && k != :errors }
      resource_data = json[resource_key]

      # Spyke expects single hash for find() and array for collections
      # Pike13 API usually returns arrays, but some singleton endpoints return objects
      # - GETs to /resource/id or /resource/me should unwrap single-element arrays
      # - POSTs (create) and PUTs (update) should unwrap single-element arrays
      # - Singleton resources (returning Hash, not Array) should be wrapped in arrays for .all
      path = env.url.path
      method = env.method
      is_single_resource = path.match?(%r{/(\d+|me)$}) || %i[post put].include?(method)

      data = if resource_data.is_a?(Array)
               # Array data: unwrap if single element and single resource request
               resource_data.size == 1 && is_single_resource ? resource_data.first : resource_data
             else
               # Hash data (singleton resources): wrap in array unless single resource request
               is_single_resource ? resource_data : [resource_data]
             end

      env.body = {
        data: data,
        metadata: json.except(resource_key, :errors),
        errors: json[:errors] || {}
      }
    end
  end

  class Connection
    DEFAULT_RETRY_MAX = 2
    DEFAULT_RETRY_INTERVAL = 0.5
    DEFAULT_RETRY_BACKOFF_FACTOR = 2
    UNSCOPED_BASE_URL = "https://pike13.com"

    attr_reader :config, :faraday_connection, :unscoped_faraday_connection

    def initialize(config)
      @config = config
      @faraday_connection = build_faraday_connection
      @unscoped_faraday_connection = build_unscoped_faraday_connection
    end

    def build_faraday_connection
      Faraday.new(url: "#{config.normalized_base_url}#{config.api_version}") do |c|
        c.request :retry,
                  max: DEFAULT_RETRY_MAX,
                  interval: DEFAULT_RETRY_INTERVAL,
                  backoff_factor: DEFAULT_RETRY_BACKOFF_FACTOR
        c.request :json
        c.use Pike13JSONParser
        c.response :json, content_type: /\bjson$/
        c.headers["Authorization"] = "Bearer #{config.access_token}"
        c.adapter Faraday.default_adapter
      end
    end

    def build_unscoped_faraday_connection
      Faraday.new(url: "#{UNSCOPED_BASE_URL}#{config.api_version}") do |c|
        c.request :retry,
                  max: DEFAULT_RETRY_MAX,
                  interval: DEFAULT_RETRY_INTERVAL,
                  backoff_factor: DEFAULT_RETRY_BACKOFF_FACTOR
        c.request :json
        c.use Pike13JSONParser
        c.response :json, content_type: /\bjson$/
        c.headers["Authorization"] = "Bearer #{config.access_token}"
        c.adapter Faraday.default_adapter
      end
    end
  end
end
