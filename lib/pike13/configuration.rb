# frozen_string_literal: true

module Pike13
  class Configuration
    attr_accessor :access_token, :base_url

    def initialize
      @access_token = nil
      @base_url = "https://pike13.com"
    end

    # Returns the normalized base URL (adds https:// if missing)
    # Infers http:// for localhost/.test domains, https:// otherwise
    #
    # @return [String]
    def full_url
      return base_url if base_url.to_s.start_with?("http://", "https://")

      "#{inferred_scheme}://#{base_url}"
    end

    # Returns the normalized account base URL
    # Extracts the domain and port from base_url
    #
    # @return [String]
    def account_full_url
      # Extract domain from base_url (strip subdomain, keep domain + port)
      url = base_url.to_s.sub(%r{^https?://}, "")

      # Extract domain and port
      parts = url.split(".")
      if parts.length >= 2
        # Keep last two parts (domain.tld) plus port if exists
        domain_parts = parts[-2..]
        domain_with_port = domain_parts.join(".")
      else
        # Single part (like localhost), keep as is
        domain_with_port = url
      end

      "#{inferred_scheme}://#{domain_with_port}"
    end

    # Validates the configuration
    #
    # @raise [Pike13::ConfigurationError] if configuration is invalid
    def validate!
      raise Pike13::ConfigurationError, "access_token is required" unless access_token
    end

    private

    def inferred_scheme
      url = base_url.to_s.sub(%r{^https?://}, "")
      url.start_with?("localhost") || url.include?(".test") ? "http" : "https"
    end
  end
end
