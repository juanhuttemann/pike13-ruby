# frozen_string_literal: true

require_relative "pike13/version"
require_relative "pike13/configuration"
require_relative "pike13/errors"
require_relative "pike13/http_client"
require_relative "pike13/http_client_v3"
require_relative "pike13/validators"

# Namespace base classes
require_relative "pike13/api/v2/desk/base"
require_relative "pike13/api/v2/front/base"
require_relative "pike13/api/v2/account/base"
require_relative "pike13/api/v3/desk/base"

# Account namespace resources
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
require_relative "pike13/api/v2/desk/event_occurrence_note"
require_relative "pike13/api/v2/desk/event_occurrence_visit"
require_relative "pike13/api/v2/desk/event_occurrence_waitlist_entry"
require_relative "pike13/api/v2/desk/form_of_payment"
require_relative "pike13/api/v2/desk/invoice"
require_relative "pike13/api/v2/desk/location"
require_relative "pike13/api/v2/desk/note"
require_relative "pike13/api/v2/desk/pack"
require_relative "pike13/api/v2/desk/pack_product"
require_relative "pike13/api/v2/desk/person"
require_relative "pike13/api/v2/desk/person_plan"
require_relative "pike13/api/v2/desk/person_visit"
require_relative "pike13/api/v2/desk/person_waitlist_entry"
require_relative "pike13/api/v2/desk/person_waiver"
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
require_relative "pike13/api/v2/front/event_occurrence_note"
require_relative "pike13/api/v2/front/event_occurrence_waitlist_eligibility"
require_relative "pike13/api/v2/front/form_of_payment"
require_relative "pike13/api/v2/front/invoice"
require_relative "pike13/api/v2/front/location"
require_relative "pike13/api/v2/front/note"
require_relative "pike13/api/v2/front/person"
require_relative "pike13/api/v2/front/person_plan"
require_relative "pike13/api/v2/front/person_visit"
require_relative "pike13/api/v2/front/person_waitlist_entry"
require_relative "pike13/api/v2/front/person_waiver"
require_relative "pike13/api/v2/front/plan"
require_relative "pike13/api/v2/front/plan_product"
require_relative "pike13/api/v2/front/plan_terms"
require_relative "pike13/api/v2/front/service"
require_relative "pike13/api/v2/front/staff_member"
require_relative "pike13/api/v2/front/visit"
require_relative "pike13/api/v2/front/waitlist_entry"
require_relative "pike13/api/v2/front/payment"

# V3 Reporting resources
require_relative "pike13/api/v3/desk/clients"
require_relative "pike13/api/v3/desk/enrollments"
require_relative "pike13/api/v3/desk/event_occurrences"
require_relative "pike13/api/v3/desk/event_occurrence_staff_members"
require_relative "pike13/api/v3/desk/invoice_items"
require_relative "pike13/api/v3/desk/invoice_item_transactions"
require_relative "pike13/api/v3/desk/invoices"
require_relative "pike13/api/v3/desk/monthly_business_metrics"
require_relative "pike13/api/v3/desk/pays"
require_relative "pike13/api/v3/desk/person_plans"
require_relative "pike13/api/v3/desk/staff_members"
require_relative "pike13/api/v3/desk/transactions"

# Pike13 Ruby Client
#
# A Ruby gem for interacting with the Pike13 API.
#
# @example Configuration
#   Pike13.configure do |config|
#     config.access_token = "your_access_token"
#     config.base_url = "mybusiness.pike13.com"
#   end
#
#   # Then use models directly
#   person = Pike13::API::V2::Desk::Person.find(123)
#   people = Pike13::API::V2::Desk::Person.all
#
# @example Using different namespaces
#   # Account namespace (not scoped to business subdomain)
#   account = Pike13::Account.me
#   businesses = Pike13::Account::Business.all
#
#   # Desk namespace (staff interface)
#   people = Pike13::Desk::Person.all
#   events = Pike13::Desk::Event.all
#
#   # Front namespace (client interface)
#   locations = Pike13::Front::Location.all
#   branding = Pike13::Front::Branding.all.first
module Pike13
  # Simplified namespace aliases
  Account = API::V2::Account
  Desk = API::V2::Desk
  Front = API::V2::Front
  Reporting = API::V3::Desk

  class << self
    attr_writer :configuration

    # Returns the global configuration object
    #
    # @return [Configuration]
    def configuration
      @configuration ||= Configuration.new
    end

    # Configure Pike13 globally
    #
    # Automatically applies configuration to all API Base classes.
    #
    # @yield [Configuration] Global configuration object
    #
    # @example
    #   Pike13.configure do |config|
    #     config.access_token = "your_access_token"
    #     config.base_url = "mybusiness.pike13.com"
    #   end
    #
    #   # Then use models directly
    #   person = Pike13::API::V2::Desk::Person.find(123)
    def configure
      yield(configuration)
      configuration.validate!
      apply_configuration!
    end

    # Reset configuration (mainly for testing)
    #
    # @return [Configuration] New configuration object
    def reset!
      @configuration = Configuration.new
    end

    private

    # Apply configuration to all API Base classes
    def apply_configuration!
      API::V2::Desk::Base.configure(configuration)
      API::V2::Front::Base.configure(configuration)
      API::V2::Account::Base.configure(configuration)
      API::V3::Desk::Base.configure(configuration)
    end
  end
end
