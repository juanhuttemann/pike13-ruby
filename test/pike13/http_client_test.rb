# frozen_string_literal: true

require "test_helper"

module Pike13
  class HTTPClientTest < Minitest::Test
    def setup
      @config = Configuration.new
      @config.access_token = "test_token"
      @config.base_url = "test.pike13.com"
      @client = HTTPClient.new(@config)
    end

    def test_get_request_success
      stub_request(:get, "https://pike13.com/api/v2/test")
        .to_return(status: 200, body: '{"data": "success"}', headers: { "Content-Type" => "application/json" })

      response = @client.get("/test")

      assert_equal({ "data" => "success" }, response)
    end

    def test_get_request_with_scoped_url
      stub_request(:get, "https://test.pike13.com/api/v2/desk/people")
        .to_return(status: 200, body: '{"people": []}', headers: { "Content-Type" => "application/json" })

      response = @client.get("/desk/people", scoped: true)

      assert_equal({ "people" => [] }, response)
    end

    def test_handles_401_unauthorized
      stub_request(:get, "https://pike13.com/api/v2/test")
        .to_return(status: 401, body: '{"error": "Unauthorized"}', headers: { "Content-Type" => "application/json" })

      assert_raises(Pike13::AuthenticationError) do
        @client.get("/test")
      end
    end

    def test_handles_404_not_found
      stub_request(:get, "https://pike13.com/api/v2/test")
        .to_return(status: 404, body: '{"error": "Not found"}', headers: { "Content-Type" => "application/json" })

      assert_raises(Pike13::NotFoundError) do
        @client.get("/test")
      end
    end

    def test_handles_429_rate_limit
      stub_request(:get, "https://pike13.com/api/v2/test")
        .to_return(
          status: 429,
          body: '{"error": "Rate limit exceeded"}',
          headers: { "RateLimit-Reset" => "1760806980", "Content-Type" => "application/json" }
        )

      error = assert_raises(Pike13::RateLimitError) do
        @client.get("/test")
      end

      assert_equal 429, error.http_status
      assert_equal "1760806980", error.rate_limit_reset
    end

    def test_handles_500_server_error
      stub_request(:get, "https://pike13.com/api/v2/test")
        .to_return(status: 500,
                   body: '{"error": "Internal server error"}',
                   headers: { "Content-Type" => "application/json" })

      assert_raises(Pike13::ServerError) do
        @client.get("/test")
      end
    end
  end
end
