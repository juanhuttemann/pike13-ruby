# frozen_string_literal: true

require "faraday"
require "faraday/retry"
require "json"

module Pike13
  class HTTPClient
    RATE_LIMIT_HEADER = "RateLimit-Reset"

    attr_reader :config

    def initialize(config)
      @config = config
    end

    # Perform a GET request
    # Automatically determines if request should be scoped based on path
    # (/account/* uses pike13.com, everything else uses business subdomain)
    #
    # @param path [String] The API path
    # @param params [Hash] Query parameters
    # @return [Hash] Parsed JSON response
    def get(path, params: {})
      # Auto-detect scoping: /account/* is unscoped, everything else is scoped
      scoped = !path.start_with?("/account")

      full_path = "#{config.api_version}#{build_path(path)}"
      response = connection(scoped).get do |req|
        req.url full_path
        req.params = params if params.any?
      end

      handle_response(response)
    end

    private

    def connection(scoped)
      base_url = scoped ? config.normalized_base_url : "https://pike13.com"

      @connections ||= {}
      @connections["#{base_url}_#{scoped}"] ||= Faraday.new(url: base_url) do |conn|
        conn.request :retry, max: 2, interval: 0.5, backoff_factor: 2
        conn.response :json, content_type: /\bjson$/
        conn.headers["Authorization"] = "Bearer #{config.access_token}"
        conn.adapter Faraday.default_adapter
      end
    end

    def build_path(path)
      path.start_with?("/") ? path : "/#{path}"
    end

    def handle_response(response)
      return response.body if response.status.between?(200, 299)

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
      error_class.new(
        message,
        http_status: response.status,
        response_body: response.body
      )
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
