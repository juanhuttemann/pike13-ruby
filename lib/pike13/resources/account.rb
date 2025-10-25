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
    def initialize(client)
      @client = client
    end

    def businesses
      API::V2::Account::Business
    end

    def people
      API::V2::Account::Person
    end

    def passwords
      API::V2::Account::Password
    end

    def confirmations
      API::V2::Account::Confirmation
    end

    # Get current account details
    #
    # @return [Pike13::API::V2::Account::Base] Account instance
    #
    # @example
    #   account = client.account.me
    #   puts account.email
    def me
      API::V2::Account::Base.me
    end
  end
end
