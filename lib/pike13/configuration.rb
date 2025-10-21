# frozen_string_literal: true

require "uri"

module Pike13
  class Configuration
    attr_accessor :access_token, :base_url
    attr_reader :api_version

    def initialize
      @base_url = nil
      @api_version = "/api/v2"
      @access_token = nil
    end

    # Returns the normalized base URL
    #
    # @return [String]
    def normalized_base_url
      return validate_and_normalize_url(base_url) if base_url

      "https://pike13.com"
    end

    # Returns URL for account endpoints (always pike13.com)
    #
    # @return [String]
    def account_url
      "https://pike13.com#{api_version}"
    end

    # Returns URL for scoped endpoints (desk/front)
    #
    # @return [String]
    def scoped_url
      "#{normalized_base_url}#{api_version}"
    end

    # Validates the configuration
    #
    # @raise [Pike13::ConfigurationError] if configuration is invalid
    def validate!
      raise Pike13::ConfigurationError, "access_token is required" unless access_token

      # Validate base_url if provided
      validate_and_normalize_url(base_url) if base_url
    end

    private

    # Validates and normalizes a URL
    #
    # @param url [String] The URL to validate
    # @return [String] The normalized URL
    # @raise [Pike13::ConfigurationError] if URL is invalid
    def validate_and_normalize_url(url)
      return nil unless url

      normalized_url = add_scheme_if_missing(url)
      uri = parse_and_validate_uri(normalized_url)
      build_normalized_url(uri)
    rescue URI::InvalidURIError => e
      raise Pike13::ConfigurationError, "Invalid base_url: #{e.message}"
    end

    def add_scheme_if_missing(url)
      url.include?("://") ? url : "https://#{url}"
    end

    def parse_and_validate_uri(url)
      uri = URI.parse(url)
      validate_scheme(uri)
      validate_host(uri)
      uri
    end

    def validate_scheme(uri)
      raise Pike13::ConfigurationError, "base_url must use http or https scheme" unless uri.scheme&.match?(/^https?$/)
    end

    def validate_host(uri)
      raise Pike13::ConfigurationError, "base_url must include a valid host" unless uri.host
    end

    def build_normalized_url(uri)
      normalized = "#{uri.scheme}://#{uri.host}"
      normalized += ":#{uri.port}" if uri.port && ![80, 443].include?(uri.port)
      normalized
    end
  end
end
