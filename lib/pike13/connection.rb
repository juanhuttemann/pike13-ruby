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
    RATE_LIMIT_HEADER = "RateLimit-Reset"
    DEFAULT_RETRY_MAX = 2
    DEFAULT_RETRY_INTERVAL = 0.5
    DEFAULT_RETRY_BACKOFF_FACTOR = 2
    ACCOUNT_PATH_PREFIX = "/account"
    UNSCOPED_BASE_URL = "https://pike13.com"

    attr_reader :config, :faraday_connection

    def initialize(config)
      @config = config
      @faraday_connection = build_faraday_connection
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

    # Perform a GET request
    # Automatically determines if request should be scoped based on path
    # (/account/* uses pike13.com, everything else uses business subdomain)
    #
    # @param path [String] The API path
    # @param params [Hash] Query parameters
    # @return [Hash] Parsed JSON response
    def get(path, params: {})
      scoped = scoped_path?(path)
      full_path = "#{config.api_version}#{build_path(path)}"
      response = connection(scoped).get do |req|
        req.url full_path
        req.params = params if params.any?
      end

      handle_response(response)
    end

    # Perform a POST request
    # Automatically determines if request should be scoped based on path
    #
    # @param path [String] The API path
    # @param body [Hash] Request body
    # @param params [Hash] Query parameters
    # @return [Hash] Parsed JSON response
    def post(path, body: {}, params: {})
      scoped = scoped_path?(path)
      full_path = "#{config.api_version}#{build_path(path)}"
      response = connection(scoped).post do |req|
        req.url full_path
        req.params = params if params.any?
        req.headers["Content-Type"] = "application/json"
        req.body = body.to_json if body.any?
      end

      handle_response(response)
    end

    # Perform a PUT request
    # Automatically determines if request should be scoped based on path
    #
    # @param path [String] The API path
    # @param body [Hash] Request body
    # @param params [Hash] Query parameters
    # @return [Hash] Parsed JSON response
    def put(path, body: {}, params: {})
      scoped = scoped_path?(path)
      full_path = "#{config.api_version}#{build_path(path)}"
      response = connection(scoped).put do |req|
        req.url full_path
        req.params = params if params.any?
        req.headers["Content-Type"] = "application/json"
        req.body = body.to_json if body.any?
      end

      handle_response(response)
    end

    # Perform a DELETE request
    # Automatically determines if request should be scoped based on path
    #
    # @param path [String] The API path
    # @param params [Hash] Query parameters
    # @return [Hash] Parsed JSON response
    def delete(path, params: {})
      scoped = scoped_path?(path)
      full_path = "#{config.api_version}#{build_path(path)}"
      response = connection(scoped).delete do |req|
        req.url full_path
        req.params = params if params.any?
      end

      handle_response(response)
    end

    private

    # Check if the API path requires business subdomain scoping
    # Account endpoints (/account/*) are unscoped and use pike13.com
    # Desk and Front endpoints are scoped to business subdomain
    #
    # @param path [String] The API path
    # @return [Boolean] true if path should use business subdomain
    def scoped_path?(path)
      !path.start_with?(ACCOUNT_PATH_PREFIX)
    end

    def connection(scoped)
      base_url = scoped ? config.normalized_base_url : UNSCOPED_BASE_URL
      connection_key = connection_pool_key(base_url, scoped)

      @connections ||= {}
      @connections[connection_key] ||= build_connection(base_url)
    end

    def connection_pool_key(base_url, scoped)
      scope_type = scoped ? "scoped" : "unscoped"
      "#{base_url}:#{scope_type}"
    end

    def build_connection(base_url)
      Faraday.new(url: base_url) do |conn|
        conn.request :retry,
                     max: DEFAULT_RETRY_MAX,
                     interval: DEFAULT_RETRY_INTERVAL,
                     backoff_factor: DEFAULT_RETRY_BACKOFF_FACTOR
        conn.response :json, content_type: /\bjson$/
        conn.headers["Authorization"] = "Bearer #{config.access_token}"
        conn.adapter Faraday.default_adapter
      end
    end

    def build_path(path)
      path.start_with?("/") ? path : "/#{path}"
    end

    def handle_response(response)
      return response.body if response.success?

      raise_error_for_status(response)
    end

    def raise_error_for_status(response)
      case response.status
      when 401 then raise build_error(AuthenticationError, "Authentication failed", response)
      when 404 then raise build_error(NotFoundError, "Resource not found", response)
      when 422 then raise build_error(ValidationError, "Validation failed", response)
      when 429 then raise build_rate_limit_error(response)
      when 500..599 then raise build_error(ServerError, "Server error", response)
      else raise build_error(APIError, "API request failed", response)
      end
    end

    def build_error(error_class, message, response)
      enhanced_message = build_error_message(message, response)
      error_class.new(
        enhanced_message,
        http_status: response.status,
        response_body: response.body
      )
    end

    def build_error_message(base_message, response)
      return base_message unless response.body.is_a?(Hash)

      error_detail = response.body["error"] || response.body["message"]
      return base_message unless error_detail

      "#{base_message}: #{error_detail}"
    end

    def build_rate_limit_error(response)
      RateLimitError.new(
        "Rate limit exceeded",
        http_status: response.status,
        response_body: response.body,
        rate_limit_reset: response.headers[RATE_LIMIT_HEADER]
      )
    end
  end
end
