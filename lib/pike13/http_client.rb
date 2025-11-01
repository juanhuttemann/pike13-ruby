# frozen_string_literal: true

require "httparty"
require "json"

module Pike13
  # HTTParty-based HTTP client for Pike13 API
  # Provides  HTTP methods with error handling
  class HTTPClient
    include HTTParty

    attr_reader :base_url, :access_token

    def initialize(base_url:, access_token:)
      @base_url = base_url
      @access_token = access_token
    end

    # GET request
    #
    # @param path [String] The API endpoint path
    # @param params [Hash] Query parameters
    # @return [Hash, Array] Parsed response body
    def get(path, params = {})
      handle_response do
        self.class.get(
          full_path(path),
          query: params,
          headers: headers,
          timeout: 30
        )
      end
    end

    # POST request
    #
    # @param path [String] The API endpoint path
    # @param body [Hash] Request body
    # @param params [Hash] Query parameters
    # @return [Hash] Parsed response body
    def post(path, body = {}, params = {})
      handle_response do
        self.class.post(
          full_path(path),
          body: body.to_json,
          query: params,
          headers: headers,
          timeout: 30
        )
      end
    end

    # PUT request
    #
    # @param path [String] The API endpoint path
    # @param body [Hash] Request body
    # @param params [Hash] Query parameters
    # @return [Hash] Parsed response body
    def put(path, body = {}, params = {})
      handle_response do
        self.class.put(
          full_path(path),
          body: body.to_json,
          query: params,
          headers: headers,
          timeout: 30
        )
      end
    end

    # PATCH request
    #
    # @param path [String] The API endpoint path
    # @param body [Hash] Request body
    # @param params [Hash] Query parameters
    # @return [Hash] Parsed response body
    def patch(path, body = {}, params = {})
      handle_response do
        self.class.patch(
          full_path(path),
          body: body.to_json,
          query: params,
          headers: headers,
          timeout: 30
        )
      end
    end

    # DELETE request
    #
    # @param path [String] The API endpoint path
    # @param params [Hash] Query parameters
    # @return [Hash] Parsed response body
    def delete(path, params = {})
      handle_response do
        self.class.delete(
          full_path(path),
          query: params,
          headers: headers,
          timeout: 30
        )
      end
    end

    private

    def full_path(path)
      "#{base_url}/api/v2/#{path}"
    end

    def headers
      {
        "Authorization" => "Bearer #{access_token}",
        "Content-Type" => "application/json",
        "Accept" => "application/json"
      }
    end

    def handle_response
      response = yield
      handle_status_code(response)
    rescue HTTParty::Error => e
      raise Pike13::ConnectionError, "Connection failed: #{e.message}"
    end

    def handle_status_code(response)
      return parse_response_body(response) if response.code.between?(200, 299)

      raise_error_for_status(response)
    end

    def raise_error_for_status(response)
      case response.code
      when 400 then raise Pike13::BadRequestError.new(response.body, http_status: response.code)
      when 401 then raise Pike13::UnauthorizedError.new("Unauthorized", http_status: response.code)
      when 404 then raise Pike13::NotFoundError.new("Resource not found", http_status: response.code)
      when 422 then raise_validation_error(response)
      when 429 then raise Pike13::RateLimitError.new("Rate limit exceeded", http_status: response.code)
      when 500..599 then raise Pike13::ServerError.new("Server error", http_status: response.code)
      else raise Pike13::APIError.new("Unexpected error", http_status: response.code)
      end
    end

    def raise_validation_error(response)
      parsed = parse_json_safely(response.body)
      error_message = extract_error_message(parsed, response.body)
      raise Pike13::ValidationError.new(error_message, http_status: response.code)
    end

    def parse_json_safely(body)
      JSON.parse(body)
    rescue StandardError
      {}
    end

    def extract_error_message(parsed, fallback)
      return fallback unless parsed.is_a?(Hash) && parsed["errors"]

      parsed["errors"].is_a?(Array) ? parsed["errors"].first : parsed["errors"]
    end

    def parse_response_body(response)
      return nil if response.body.nil? || response.body.empty?

      parsed = response.parsed_response

      # If parsed response is not a Hash (e.g., it's an Array), return as-is
      return parsed unless parsed.is_a?(Hash)

      # Handle different response formats for Hash responses
      if parsed.key?("data")
        parsed["data"]
      else
        parsed
      end
    end
  end
end
