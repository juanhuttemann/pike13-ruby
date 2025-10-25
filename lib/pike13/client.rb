# frozen_string_literal: true

module Pike13
  class Client
    attr_reader :config, :connection

    # Initialize a new Pike13 client
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
    #   person = client.desk.people.find(123)
    #   puts person.name
    #
    # @example List resources with pagination
    #   events = client.desk.events.all(page: 1, per_page: 50)
    #   events.each { |event| puts event.name }
    #
    # @example Search for people
    #   results = client.desk.people.search("john doe")
    #
    # @example Get current user
    #   me = client.desk.people.me
    #
    # @example Handle errors
    #   begin
    #     person = client.desk.people.find(999999)
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

      @connection = Connection.new(@config)
      configure_spyke_models
    end

    def configure_spyke_models
      # Configure Spyke models to use this client's Faraday connection

      # Desk namespace
      Pike13::API::V2::Desk::Person.connection = @connection.faraday_connection
      Pike13::API::V2::Desk::Visit.connection = @connection.faraday_connection
      Pike13::API::V2::Desk::Plan.connection = @connection.faraday_connection
      Pike13::API::V2::Desk::Location.connection = @connection.faraday_connection
      Pike13::API::V2::Desk::StaffMember.connection = @connection.faraday_connection
      Pike13::API::V2::Desk::Event.connection = @connection.faraday_connection
      Pike13::API::V2::Desk::EventOccurrence.connection = @connection.faraday_connection
      Pike13::API::V2::Desk::WaitlistEntry.connection = @connection.faraday_connection
      Pike13::API::V2::Desk::Service.connection = @connection.faraday_connection
      Pike13::API::V2::Desk::Invoice.connection = @connection.faraday_connection
      Pike13::API::V2::Desk::Pack.connection = @connection.faraday_connection
      Pike13::API::V2::Desk::CustomField.connection = @connection.faraday_connection
      Pike13::API::V2::Desk::PackProduct.connection = @connection.faraday_connection
      Pike13::API::V2::Desk::PlanProduct.connection = @connection.faraday_connection
      Pike13::API::V2::Desk::RevenueCategory.connection = @connection.faraday_connection
      Pike13::API::V2::Desk::SalesTax.connection = @connection.faraday_connection
      Pike13::API::V2::Desk::Booking.connection = @connection.faraday_connection
      Pike13::API::V2::Desk::Punch.connection = @connection.faraday_connection
      Pike13::API::V2::Desk::Business.connection = @connection.faraday_connection
      Pike13::API::V2::Desk::Appointment.connection = @connection.faraday_connection
      Pike13::API::V2::Desk::Note.connection = @connection.faraday_connection

      # Front namespace
      Pike13::API::V2::Front::Person.connection = @connection.faraday_connection
      Pike13::API::V2::Front::Visit.connection = @connection.faraday_connection
      Pike13::API::V2::Front::Event.connection = @connection.faraday_connection
      Pike13::API::V2::Front::EventOccurrence.connection = @connection.faraday_connection
      Pike13::API::V2::Front::Location.connection = @connection.faraday_connection
      Pike13::API::V2::Front::Service.connection = @connection.faraday_connection
      Pike13::API::V2::Front::StaffMember.connection = @connection.faraday_connection
      Pike13::API::V2::Front::Plan.connection = @connection.faraday_connection
      Pike13::API::V2::Front::PlanProduct.connection = @connection.faraday_connection
      Pike13::API::V2::Front::WaitlistEntry.connection = @connection.faraday_connection
      Pike13::API::V2::Front::Invoice.connection = @connection.faraday_connection
      Pike13::API::V2::Front::Business.connection = @connection.faraday_connection
      Pike13::API::V2::Front::Branding.connection = @connection.faraday_connection
      Pike13::API::V2::Front::Booking.connection = @connection.faraday_connection
      Pike13::API::V2::Front::Note.connection = @connection.faraday_connection
      Pike13::API::V2::Front::Appointment.connection = @connection.faraday_connection

      # Account namespace
      Pike13::API::V2::Account::Business.connection = @connection.faraday_connection
      Pike13::API::V2::Account::Person.connection = @connection.faraday_connection
    end

    # Perform a GET request to the API (internal use)
    #
    # @param path [String] The API path
    # @param params [Hash] Query parameters
    # @return [Hash] Parsed JSON response
    # @api private
    def get(path, params: {})
      @connection.get(path, params: params)
    end

    # Perform a POST request to the API (internal use)
    #
    # @param path [String] The API path
    # @param body [Hash] Request body
    # @param params [Hash] Query parameters
    # @return [Hash] Parsed JSON response
    # @api private
    def post(path, body: {}, params: {})
      @connection.post(path, body: body, params: params)
    end

    # Perform a PUT request to the API (internal use)
    #
    # @param path [String] The API path
    # @param body [Hash] Request body
    # @param params [Hash] Query parameters
    # @return [Hash] Parsed JSON response
    # @api private
    def put(path, body: {}, params: {})
      @connection.put(path, body: body, params: params)
    end

    # Perform a DELETE request to the API (internal use)
    #
    # @param path [String] The API path
    # @param params [Hash] Query parameters
    # @return [Hash] Parsed JSON response
    # @api private
    def delete(path, params: {})
      @connection.delete(path, params: params)
    end

    # Access account namespace
    #
    # @return [Pike13::AccountResources]
    def account
      @account ||= AccountResources.new(self)
    end

    # Access desk namespace (staff interface)
    #
    # @return [Pike13::DeskResources]
    def desk
      @desk ||= DeskResources.new(self)
    end

    # Access front namespace (client interface)
    #
    # @return [Pike13::FrontResources]
    def front
      @front ||= FrontResources.new(self)
    end
  end
end
