# frozen_string_literal: true

require_relative "pike13/version"
require_relative "pike13/configuration"
require_relative "pike13/errors"
require_relative "pike13/connection"

# Spyke dependency
require "spyke"

# Account namespace and resources
require_relative "pike13/api/v2/account"
require_relative "pike13/api/v2/account/business"
require_relative "pike13/api/v2/account/person"
require_relative "pike13/api/v2/account/password"
require_relative "pike13/api/v2/account/confirmation"

# Desk resources
require_relative "pike13/api/v2/desk/appointment"
require_relative "pike13/api/v2/desk/booking"
require_relative "pike13/api/v2/desk/business"
require_relative "pike13/api/v2/desk/custom_field"
require_relative "pike13/api/v2/desk/event"
require_relative "pike13/api/v2/desk/event_occurrence"
require_relative "pike13/api/v2/desk/invoice"
require_relative "pike13/api/v2/desk/location"
require_relative "pike13/api/v2/desk/note"
require_relative "pike13/api/v2/desk/pack"
require_relative "pike13/api/v2/desk/pack_product"
require_relative "pike13/api/v2/desk/person"
require_relative "pike13/api/v2/desk/plan"
require_relative "pike13/api/v2/desk/plan_product"
require_relative "pike13/api/v2/desk/punch"
require_relative "pike13/api/v2/desk/revenue_category"
require_relative "pike13/api/v2/desk/sales_tax"
require_relative "pike13/api/v2/desk/service"
require_relative "pike13/api/v2/desk/staff_member"
require_relative "pike13/api/v2/desk/visit"
require_relative "pike13/api/v2/desk/waitlist_entry"
require_relative "pike13/api/v2/desk/payment"
require_relative "pike13/api/v2/desk/refund"
require_relative "pike13/api/v2/desk/make_up"

# Front resources
require_relative "pike13/api/v2/front/appointment"
require_relative "pike13/api/v2/front/booking"
require_relative "pike13/api/v2/front/branding"
require_relative "pike13/api/v2/front/business"
require_relative "pike13/api/v2/front/event"
require_relative "pike13/api/v2/front/event_occurrence"
require_relative "pike13/api/v2/front/invoice"
require_relative "pike13/api/v2/front/location"
require_relative "pike13/api/v2/front/note"
require_relative "pike13/api/v2/front/person"
require_relative "pike13/api/v2/front/plan"
require_relative "pike13/api/v2/front/plan_product"
require_relative "pike13/api/v2/front/service"
require_relative "pike13/api/v2/front/staff_member"
require_relative "pike13/api/v2/front/visit"
require_relative "pike13/api/v2/front/waitlist_entry"
require_relative "pike13/api/v2/front/payment"

# Resource collection base and implementations
require_relative "pike13/resource_collection"
require_relative "pike13/resources/account"
require_relative "pike13/resources/desk"
require_relative "pike13/resources/front"

# Client (must be loaded after all resources)
require_relative "pike13/client"

# Pike13 Ruby Client
#
# A Ruby gem for interacting with the Pike13 API.
# Supports both global configuration and per-client credentials.
#
# @example Global configuration
#   Pike13.configure do |config|
#     config.access_token = "your_access_token"
#     config.base_url = "mybusiness.pike13.com"
#   end
#
#   client = Pike13.new
#   people = client.desk.people.all
#
# @example Per-client configuration
#   client = Pike13.new(
#     access_token: "your_access_token",
#     base_url: "mybusiness.pike13.com"
#   )
#   person = client.desk.people.find(123)
#
# @example Using different namespaces
#   # Account namespace (not scoped to business subdomain)
#   account = client.account.me
#   businesses = client.account.businesses.all
#
#   # Desk namespace (staff interface)
#   people = client.desk.people.all
#   events = client.desk.events.all
#
#   # Front namespace (client interface)
#   locations = client.front.locations.all
#   branding = client.front.branding.find
module Pike13
  # Backward-compatible alias
  Rest = API::V2

  class << self
    attr_accessor :configuration

    # Configure Pike13 globally
    #
    # @yield [Configuration] Global configuration object
    #
    # @example
    #   Pike13.configure do |config|
    #     config.access_token = "your_access_token"
    #     config.base_url = "mybusiness.pike13.com"
    #   end
    def configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    # Create a new Pike13 client
    #
    # @param access_token [String, nil] Access token (overrides global config)
    # @param base_url [String, nil] Base URL (overrides global config)
    # @return [Pike13::Client]
    #
    # @example
    #   client = Pike13.new(access_token: "token", base_url: "mybusiness.pike13.com")
    def new(access_token: nil, base_url: nil)
      Client.new(access_token: access_token, base_url: base_url)
    end
  end
end
