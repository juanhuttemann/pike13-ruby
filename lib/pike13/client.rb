# frozen_string_literal: true

module Pike13
  class Client
    attr_reader :config

    # Initialize a new Pike13 client
    #
    # Configures Spyke model connections to use this client's credentials.
    # After initialization, use the Spyke models directly.
    #
    # @param access_token [String] Optional access token (defaults to global config)
    # @param base_url [String] Optional base URL (defaults to global config)
    #
    # @example Initialize with credentials
    #   client = Pike13::Client.new(
    #     access_token: "your_access_token",
    #     base_url: "mybusiness.pike13.com"
    #   )
    #
    # @example Find and update a person
    #   client = Pike13::Client.new(access_token: "token", base_url: "mybusiness.pike13.com")
    #   person = Pike13::API::V2::Desk::Person.find(123)
    #   puts person.name
    #
    # @example List resources with pagination
    #   client = Pike13::Client.new(access_token: "token", base_url: "mybusiness.pike13.com")
    #   events = Pike13::API::V2::Desk::Event.all(page: 1, per_page: 50)
    #   events.each { |event| puts event.name }
    #
    # @example Search for people
    #   results = Pike13::API::V2::Desk::Person.search("john doe")
    #
    # @example Get current user
    #   me = Pike13::API::V2::Desk::Person.me
    #
    # @example Handle errors
    #   begin
    #     person = Pike13::API::V2::Desk::Person.find(999999)
    #   rescue Pike13::NotFoundError => e
    #     puts "Person not found: #{e.message}"
    #   rescue Pike13::RateLimitError => e
    #     puts "Rate limited. Reset at: #{e.rate_limit_reset}"
    #   end
    def initialize(access_token: nil, base_url: nil)
      @config = Configuration.new
      @config.access_token = access_token || Pike13.configuration&.access_token
      @config.base_url = base_url || Pike13.configuration&.base_url
      @config.validate!

      # Each base class builds its own connection
      Pike13::API::V2::Desk::Base.configure(@config)
      Pike13::API::V2::Front::Base.configure(@config)
      Pike13::API::V2::Account::Base.configure(@config)
    end
  end
end
