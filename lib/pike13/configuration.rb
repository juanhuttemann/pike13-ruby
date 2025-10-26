# frozen_string_literal: true

module Pike13
  class Configuration
    attr_accessor :access_token, :base_url

    def initialize
      @access_token = nil
      @base_url = "https://pike13.com"
    end

    # Returns the normalized base URL (adds https:// if missing)
    #
    # @return [String]
    def full_url
      return base_url if base_url.to_s.start_with?("http://", "https://")

      "https://#{base_url}"
    end

    # Validates the configuration
    #
    # @raise [Pike13::ConfigurationError] if configuration is invalid
    def validate!
      raise Pike13::ConfigurationError, "access_token is required" unless access_token
    end
  end
end
