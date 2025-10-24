# frozen_string_literal: true

require "test_helper"

module Pike13
  class ClientTest < Minitest::Test
    def setup
      @client = Client.new(access_token: "test_token", base_url: "test.pike13.com")
    end

    def test_initialize_with_token_and_base_url
      assert_equal "test_token", @client.config.access_token
      assert_equal "test.pike13.com", @client.config.base_url
    end

    def test_initialize_uses_global_config
      Pike13.configure do |config|
        config.access_token = "global_token"
        config.base_url = "global.pike13.com"
      end

      client = Client.new

      assert_equal "global_token", client.config.access_token
      assert_equal "global.pike13.com", client.config.base_url
    end

    def test_account_returns_account_resource
      assert_instance_of Pike13::AccountResources, @client.account
    end

    def test_desk_returns_desk_resource
      assert_instance_of Pike13::DeskResources, @client.desk
    end

    def test_front_returns_front_resource
      assert_instance_of Pike13::FrontResources, @client.front
    end

    def test_account_is_memoized
      assert_same @client.account, @client.account
    end

    def test_desk_is_memoized
      assert_same @client.desk, @client.desk
    end

    def test_front_is_memoized
      assert_same @client.front, @client.front
    end
  end
end
