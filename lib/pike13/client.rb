# frozen_string_literal: true

module Pike13
  class Client
    attr_reader :config, :http_client

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

      @http_client = HTTPClient.new(@config)
    end

    # Perform a GET request to the API
    #
    # @param path [String] The API path
    # @param params [Hash] Query parameters
    # @return [Hash] Parsed JSON response
    def get(path, params: {})
      @http_client.get(path, params: params)
    end

    # Access account namespace
    #
    # @return [Pike13::AccountNamespace]
    def account
      @account ||= AccountNamespace.new(self)
    end

    # Access desk namespace (staff interface)
    #
    # @return [Pike13::DeskNamespace]
    def desk
      @desk ||= DeskNamespace.new(self)
    end

    # Access front namespace (client interface)
    #
    # @return [Pike13::FrontNamespace]
    def front
      @front ||= FrontNamespace.new(self)
    end
  end

  # Namespace for Account resources
  #
  # Provides access to account-level API resources.
  # These endpoints are not scoped to a specific business subdomain.
  #
  # @example Get current account
  #   account = client.account.me
  #
  # @example List businesses for this account
  #   businesses = client.account.businesses.all
  #
  # @example Find a specific business
  #   business = client.account.businesses.find(123)
  class AccountNamespace
    # Define resource accessor methods using metaprogramming
    RESOURCES = {
      businesses: API::V2::Account::Business,
      people: API::V2::Account::Person
    }.freeze

    def initialize(client)
      @client = client
    end

    RESOURCES.each do |method_name, resource_class|
      define_method(method_name) do
        API::V2::ResourceProxy.new(resource_class, @client)
      end
    end

    # Access businesses
    #
    # @return [ResourceProxy] Supports find(id), all(params)
    # @example 
    #   business = client.account.businesses.find(123)
    #   all_businesses = client.account.businesses.all
    # @!method businesses

    # Access people
    #
    # @return [ResourceProxy] Supports find(id), all(params), search(query), me()
    # @example
    #   person = client.account.people.find(456)
    #   me = client.account.people.me
    # @!method people

    # Get current account details
    # Direct method to avoid account.account chaining
    #
    # @return [Pike13::API::V2::Account::Account]
    #
    # @example
    #   account = client.account.me
    def me
      API::V2::Account::Account.me(client: @client)
    end
  end

  # Namespace for Desk resources (staff interface)
  #
  # Provides access to Pike13 desk (staff) API resources.
  # Each resource supports standard methods like find() and all().
  #
  # @example Find a specific person
  #   person = client.desk.people.find(123)
  #
  # @example List all events with pagination
  #   events = client.desk.events.all(page: 2, per_page: 50)
  #
  # @example Search for people
  #   results = client.desk.people.search("john doe")
  #
  # @example Get current authenticated person
  #   me = client.desk.people.me
  class DeskNamespace
    # Define resource accessor methods using metaprogramming
    RESOURCES = {
      appointments: API::V2::Desk::Appointment,
      business: API::V2::Desk::Business,
      people: API::V2::Desk::Person,
      visits: API::V2::Desk::Visit,
      events: API::V2::Desk::Event,
      event_occurrences: API::V2::Desk::EventOccurrence,
      locations: API::V2::Desk::Location,
      services: API::V2::Desk::Service,
      custom_fields: API::V2::Desk::CustomField,
      staff_members: API::V2::Desk::StaffMember,
      invoices: API::V2::Desk::Invoice,
      plan_products: API::V2::Desk::PlanProduct,
      plans: API::V2::Desk::Plan,
      revenue_categories: API::V2::Desk::RevenueCategory,
      sales_taxes: API::V2::Desk::SalesTax,
      bookings: API::V2::Desk::Booking,
      packs: API::V2::Desk::Pack,
      pack_products: API::V2::Desk::PackProduct,
      punches: API::V2::Desk::Punch,
      waitlist_entries: API::V2::Desk::WaitlistEntry
    }.freeze

    def initialize(client)
      @client = client
    end

    RESOURCES.each do |method_name, resource_class|
      define_method(method_name) do
        API::V2::ResourceProxy.new(resource_class, @client)
      end
    end

    # Access appointments
    #
    # @return [ResourceProxy] Supports find(id), all(params)
    # @example
    #   appointment = client.desk.appointments.find(123)
    #   appointments = client.desk.appointments.all(per_page: 20)
    # @!method appointments

    # Access business details (singular resource)
    #
    # @return [ResourceProxy] Use find() without ID to get business details
    # @example
    #   business = client.desk.business.find
    # @!method business

    # Access people
    #
    # @return [ResourceProxy] Supports find(id), all(params), search(query), me()
    # @example
    #   person = client.desk.people.find(123)
    #   all_people = client.desk.people.all(page: 1, per_page: 100)
    #   search_results = client.desk.people.search("john")
    #   current_user = client.desk.people.me
    # @!method people

    # Access visits
    #
    # @return [ResourceProxy] Supports find(id), all(params)
    # @example
    #   visit = client.desk.visits.find(456)
    #   visits = client.desk.visits.all
    # @!method visits

    # Access events
    #
    # @return [ResourceProxy] Supports find(id), all(params), count(params)
    # @example
    #   event = client.desk.events.find(789)
    #   events = client.desk.events.all(per_page: 50)
    #   total = client.desk.events.count
    # @!method events

    # Access event occurrences
    #
    # @return [ResourceProxy] Supports find(id), all(params)
    # @example
    #   occurrence = client.desk.event_occurrences.find(111)
    # @!method event_occurrences

    # Access locations
    #
    # @return [ResourceProxy] Supports find(id), all(params)
    # @example
    #   location = client.desk.locations.find(222)
    # @!method locations

    # Access services
    #
    # @return [ResourceProxy] Supports find(id), all(params)
    # @example
    #   service = client.desk.services.find(333)
    # @!method services

    # Access custom fields
    #
    # @return [ResourceProxy] Supports find(id), all(params)
    # @example
    #   custom_field = client.desk.custom_fields.find(444)
    # @!method custom_fields

    # Access staff members
    #
    # @return [ResourceProxy] Supports find(id), all(params)
    # @example
    #   staff = client.desk.staff_members.find(555)
    # @!method staff_members

    # Access invoices
    #
    # @return [ResourceProxy] Supports find(id), all(params)
    # @example
    #   invoice = client.desk.invoices.find(666)
    # @!method invoices

    # Access plan products
    #
    # @return [ResourceProxy] Supports find(id), all(params)
    # @example
    #   plan_product = client.desk.plan_products.find(777)
    # @!method plan_products

    # Access plans
    #
    # @return [ResourceProxy] Supports find(id), all(params)
    # @example
    #   plan = client.desk.plans.find(888)
    # @!method plans

    # Access revenue categories
    #
    # @return [ResourceProxy] Supports find(id), all(params)
    # @example
    #   category = client.desk.revenue_categories.find(999)
    # @!method revenue_categories

    # Access sales taxes
    #
    # @return [ResourceProxy] Supports find(id), all(params)
    # @example
    #   tax = client.desk.sales_taxes.find(100)
    # @!method sales_taxes

    # Access bookings (find-only resource)
    #
    # @return [ResourceProxy] Only supports find(id), does not support all()
    # @example
    #   booking = client.desk.bookings.find(200)
    # @!method bookings

    # Access packs
    #
    # @return [ResourceProxy] Only supports find(id), does not support all()
    # @example
    #   pack = client.desk.packs.find(300)
    # @!method packs

    # Access pack products
    #
    # @return [ResourceProxy] Supports find(id), all(params)
    # @example
    #   pack_product = client.desk.pack_products.find(400)
    # @!method pack_products

    # Access punches (find-only resource)
    #
    # @return [ResourceProxy] Only supports find(id), does not support all()
    # @example
    #   punch = client.desk.punches.find(500)
    # @!method punches

    # Access waitlist entries
    #
    # @return [ResourceProxy] Supports find(id), all(params)
    # @example
    #   entry = client.desk.waitlist_entries.find(600)
    # @!method waitlist_entries
  end

  # Namespace for Front resources (client interface)
  #
  # Provides access to Pike13 front (client-facing) API resources.
  # Each resource supports standard methods like find() and all().
  #
  # @example Find a specific event
  #   event = client.front.events.find(123)
  #
  # @example List all locations
  #   locations = client.front.locations.all
  #
  # @example Get branding information
  #   branding = client.front.branding.find
  class FrontNamespace
    # Define resource accessor methods using metaprogramming
    RESOURCES = {
      appointments: API::V2::Front::Appointment,
      business: API::V2::Front::Business,
      branding: API::V2::Front::Branding,
      people: API::V2::Front::Person,
      events: API::V2::Front::Event,
      event_occurrences: API::V2::Front::EventOccurrence,
      locations: API::V2::Front::Location,
      services: API::V2::Front::Service,
      staff_members: API::V2::Front::StaffMember,
      visits: API::V2::Front::Visit,
      invoices: API::V2::Front::Invoice,
      plans: API::V2::Front::Plan,
      plan_products: API::V2::Front::PlanProduct,
      bookings: API::V2::Front::Booking,
      waitlist_entries: API::V2::Front::WaitlistEntry
    }.freeze

    def initialize(client)
      @client = client
    end

    RESOURCES.each do |method_name, resource_class|
      define_method(method_name) do
        API::V2::ResourceProxy.new(resource_class, @client)
      end
    end

    # Access appointments
    #
    # @return [ResourceProxy] Supports find(id), all(params)
    # @example
    #   appointment = client.front.appointments.find(123)
    # @!method appointments

    # Access business details (singular resource)
    #
    # @return [ResourceProxy] Use find() without ID to get business details
    # @example
    #   business = client.front.business.find
    # @!method business

    # Access branding information (singular resource)
    #
    # @return [ResourceProxy] Use find() without ID to get branding details
    # @example
    #   branding = client.front.branding.find
    # @!method branding

    # Access people
    #
    # @return [ResourceProxy] Supports find(id), all(params), search(query), me()
    # @example
    #   person = client.front.people.find(123)
    #   me = client.front.people.me
    # @!method people

    # Access events
    #
    # @return [ResourceProxy] Supports find(id), all(params)
    # @example
    #   event = client.front.events.find(456)
    # @!method events

    # Access event occurrences
    #
    # @return [ResourceProxy] Supports find(id), all(params)
    # @example
    #   occurrence = client.front.event_occurrences.find(789)
    # @!method event_occurrences

    # Access locations
    #
    # @return [ResourceProxy] Supports find(id), all(params)
    # @example
    #   location = client.front.locations.find(111)
    # @!method locations

    # Access services
    #
    # @return [ResourceProxy] Supports find(id), all(params)
    # @example
    #   service = client.front.services.find(222)
    # @!method services

    # Access staff members
    #
    # @return [ResourceProxy] Supports find(id), all(params)
    # @example
    #   staff = client.front.staff_members.find(333)
    # @!method staff_members

    # Access visits
    #
    # @return [ResourceProxy] Supports find(id), all(params)
    # @example
    #   visit = client.front.visits.find(444)
    # @!method visits

    # Access invoices (find-only resource)
    #
    # @return [ResourceProxy] Only supports find(id), does not support all()
    # @example
    #   invoice = client.front.invoices.find(555)
    # @!method invoices

    # Access plans
    #
    # @return [ResourceProxy] Supports find(id), all(params)
    # @example
    #   plan = client.front.plans.find(666)
    # @!method plans

    # Access plan products
    #
    # @return [ResourceProxy] Supports find(id), all(params)
    # @example
    #   plan_product = client.front.plan_products.find(777)
    # @!method plan_products

    # Access bookings (find-only resource)
    #
    # @return [ResourceProxy] Only supports find(id), does not support all()
    # @example
    #   booking = client.front.bookings.find(888)
    # @!method bookings

    # Access waitlist entries (find-only resource)
    #
    # @return [ResourceProxy] Only supports find(id), does not support all()
    # @example
    #   entry = client.front.waitlist_entries.find(999)
    # @!method waitlist_entries
  end
end
