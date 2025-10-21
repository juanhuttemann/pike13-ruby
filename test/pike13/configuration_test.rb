# frozen_string_literal: true

require "test_helper"

module Pike13
  class ConfigurationTest < Minitest::Test
    def setup
      @config = Configuration.new
    end

    def test_default_values
      assert_nil @config.access_token
      assert_nil @config.base_url
      assert_equal "https://pike13.com", @config.normalized_base_url
    end

    def test_setting_access_token
      @config.access_token = "test_token_123"

      assert_equal "test_token_123", @config.access_token
    end

    def test_setting_base_url
      @config.base_url = "mybusiness.pike13.com"

      assert_equal "mybusiness.pike13.com", @config.base_url
    end

    def test_normalized_base_url_with_full_url
      @config.base_url = "https://mybusiness.pike13.com"

      assert_equal "https://mybusiness.pike13.com", @config.normalized_base_url
    end

    def test_normalized_base_url_without_scheme
      @config.base_url = "mybusiness.pike13.com"

      assert_equal "https://mybusiness.pike13.com", @config.normalized_base_url
    end

    def test_normalized_base_url_with_port
      @config.base_url = "mybusiness.pike13.test:3000"

      assert_equal "https://mybusiness.pike13.test:3000", @config.normalized_base_url
    end

    def test_normalized_base_url_with_http_scheme
      @config.base_url = "http://mybusiness.pike13.test:3000"

      assert_equal "http://mybusiness.pike13.test:3000", @config.normalized_base_url
    end

    def test_normalized_base_url_strips_trailing_slash
      @config.base_url = "https://mybusiness.pike13.com/"

      assert_equal "https://mybusiness.pike13.com", @config.normalized_base_url
    end

    def test_normalized_base_url_without_base_url
      assert_equal "https://pike13.com", @config.normalized_base_url
    end

    def test_account_url
      assert_equal "https://pike13.com/api/v2", @config.account_url
    end

    def test_scoped_url_with_base_url
      @config.base_url = "mybusiness.pike13.com"

      assert_equal "https://mybusiness.pike13.com/api/v2", @config.scoped_url
    end

    def test_scoped_url_without_base_url
      assert_equal "https://pike13.com/api/v2", @config.scoped_url
    end

    def test_validate_raises_when_token_missing
      error = assert_raises(Pike13::ConfigurationError) { @config.validate! }
      assert_match(/access_token is required/, error.message)
    end

    def test_validate_passes_when_token_present
      @config.access_token = "test_token"

      assert_nil @config.validate!
    end

    def test_validate_raises_on_invalid_url
      @config.access_token = "test_token"
      @config.base_url = "not a valid url!!!"

      error = assert_raises(Pike13::ConfigurationError) { @config.validate! }
      assert_match(/Invalid base_url/, error.message)
    end

    def test_validate_raises_on_invalid_scheme
      @config.access_token = "test_token"
      @config.base_url = "ftp://mybusiness.pike13.com"

      error = assert_raises(Pike13::ConfigurationError) { @config.validate! }
      assert_match(/must use http or https scheme/, error.message)
    end
  end
end
