# frozen_string_literal: true

module Pike13
  # Base error class for all Pike13 errors
  class Error < StandardError; end

  # Raised when configuration is invalid or missing
  #
  # @example
  #   Pike13::Client.new  # raises ConfigurationError: "access_token is required"
  class ConfigurationError < Error; end

  # Base class for all API-related errors
  # Provides access to HTTP status and response body
  #
  # @attr_reader [Integer, nil] http_status HTTP status code from the API
  # @attr_reader [Hash, String, nil] response_body Response body from the API
  class APIError < Error
    attr_reader :http_status, :response_body

    # @param message [String, nil] Error message
    # @param http_status [Integer, nil] HTTP status code
    # @param response_body [Hash, String, nil] API response body
    def initialize(message = nil, http_status: nil, response_body: nil)
      @http_status = http_status
      @response_body = response_body
      super(message)
    end
  end

  # Raised when authentication fails (HTTP 401)
  #
  # @example
  #   begin
  #     client.desk.people.all
  #   rescue Pike13::AuthenticationError => e
  #     puts "Invalid access token: #{e.message}"
  #   end
  class AuthenticationError < APIError; end

  # Alias for backward compatibility
  UnauthorizedError = AuthenticationError

  # Raised when rate limit is exceeded (HTTP 429)
  #
  # @attr_reader [String, nil] rate_limit_reset Timestamp when rate limit resets
  #
  # @example Handle rate limiting
  #   begin
  #     client.desk.people.all
  #   rescue Pike13::RateLimitError => e
  #     puts "Rate limit exceeded. Resets at: #{e.rate_limit_reset}"
  #     sleep 60
  #     retry
  #   end
  class RateLimitError < APIError
    attr_reader :rate_limit_reset

    # @param message [String, nil] Error message
    # @param http_status [Integer, nil] HTTP status code
    # @param response_body [Hash, String, nil] API response body
    # @param rate_limit_reset [String, nil] Timestamp when rate limit resets
    def initialize(message = nil, http_status: nil, response_body: nil, rate_limit_reset: nil)
      @rate_limit_reset = rate_limit_reset
      super(message, http_status: http_status, response_body: response_body)
    end
  end

  # Raised when a resource is not found (HTTP 404)
  #
  # @example
  #   begin
  #     person = client.desk.people.find(999999)
  #   rescue Pike13::NotFoundError => e
  #     puts "Person not found"
  #   end
  class NotFoundError < APIError; end

  # Raised when validation fails (HTTP 422)
  #
  # @example
  #   begin
  #     # attempt to create/update with invalid data
  #   rescue Pike13::ValidationError => e
  #     puts "Validation failed: #{e.response_body}"
  #   end
  class ValidationError < APIError; end

  # Raised when server error occurs (HTTP 5xx)
  #
  # @example
  #   begin
  #     client.desk.people.all
  #   rescue Pike13::ServerError => e
  #     puts "Server error: #{e.http_status}"
  #   end
  class ServerError < APIError; end

  # Raised when request is malformed (HTTP 400)
  class BadRequestError < APIError; end

  # Raised when connection to API fails
  class ConnectionError < Error; end
end
