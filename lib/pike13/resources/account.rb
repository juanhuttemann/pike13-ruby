# frozen_string_literal: true

module Pike13
  # Account-level API resources
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
  class AccountResources
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
end
