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
  class AccountResources < ResourceCollection
    register_resources(
      businesses: API::V2::Account::Business,
      people: API::V2::Account::Person
    )

    # Get current account details
    #
    # @return [Hash] Account data
    #
    # @example
    #   account = client.account.me
    #   puts account[:email]
    def me
      API::V2::Account.me(client: @client)
    end
  end
end
