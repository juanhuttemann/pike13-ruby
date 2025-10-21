# frozen_string_literal: true

require "simplecov"
SimpleCov.start do
  add_filter "/test/"
  add_filter "/vendor/"
  enable_coverage :branch
  minimum_coverage line: 90, branch: 65
end

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "pike13"
require "minitest/autorun"
require "minitest/reporters"
require "webmock/minitest"
require "vcr"
require "dotenv/load"

Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new]

# VCR configuration for recording HTTP interactions (optional for integration tests)
# VCR.configure do |config|
#   config.cassette_library_dir = "test/vcr_cassettes"
#   config.hook_into :webmock
#   config.filter_sensitive_data("<ACCESS_TOKEN>") { ENV["PIKE13_ACCESS_TOKEN"] }
#   config.filter_sensitive_data("<SUBDOMAIN>") { ENV["PIKE13_SUBDOMAIN"] }
# end

module TestHelpers
  def stub_pike13_request(method, path, response_body: {}, status: 200, scope: nil)
    # Build the full URL including /api/v2
    # Account scope uses pike13.com (no base_url)
    # Desk/Front scopes use base_url
    base_url = if scope && scope != "account"
                 "https://#{ENV.fetch("PIKE13_BASE_URL", "test.pike13.com")}/api/v2"
               else
                 "https://pike13.com/api/v2"
               end

    # Path should already include the scope (desk/front) if needed
    full_url = "#{base_url}#{path}"

    stub_request(method, full_url)
      .with(headers: { "Authorization" => "Bearer #{ENV.fetch("PIKE13_ACCESS_TOKEN", "test_token")}" })
      .to_return(status: status, body: response_body.to_json, headers: { "Content-Type" => "application/json" })
  end

  def default_client
    Pike13::Client.new(
      access_token: ENV.fetch("PIKE13_ACCESS_TOKEN", "test_token"),
      base_url: ENV.fetch("PIKE13_BASE_URL", "test.pike13.com")
    )
  end
end

module Minitest
  class Test
    include TestHelpers
  end
end
