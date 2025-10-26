# frozen_string_literal: true

require "test_helper"

class Pike13Test < Minitest::Test
  def teardown
    Pike13.reset!
  end

  def test_configure_sets_configuration
    Pike13.configure do |config|
      config.access_token = "test_token"
      config.base_url = "mybusiness.pike13.com"
    end

    assert_equal "test_token", Pike13.configuration.access_token
    assert_equal "mybusiness.pike13.com", Pike13.configuration.base_url
  end

  def test_configure_validates_configuration
    error = assert_raises(Pike13::ConfigurationError) do
      Pike13.configure do |config|
        config.base_url = "mybusiness.pike13.com"
        # Missing access_token
      end
    end

    assert_match(/access_token is required/, error.message)
  end

  def test_reset_clears_configuration
    Pike13.configure do |config|
      config.access_token = "test_token"
      config.base_url = "mybusiness.pike13.com"
    end

    Pike13.reset!

    assert_nil Pike13.configuration.access_token
    assert_equal "https://pike13.com", Pike13.configuration.base_url
  end

  def test_configuration_returns_same_instance
    config1 = Pike13.configuration
    config2 = Pike13.configuration

    assert_same config1, config2
  end
end
