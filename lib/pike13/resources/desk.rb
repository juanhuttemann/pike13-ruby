# frozen_string_literal: true

module Pike13
  # Desk API resources (staff interface)
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
  class DeskResources
    def initialize(client)
      @client = client
    end

    def appointments
      API::V2::Desk::Appointment
    end

    def business
      API::V2::Desk::Business
    end

    def people
      API::V2::Desk::Person
    end

    def visits
      API::V2::Desk::Visit
    end

    def events
      API::V2::Desk::Event
    end

    def event_occurrences
      API::V2::Desk::EventOccurrence
    end

    def locations
      API::V2::Desk::Location
    end

    def services
      API::V2::Desk::Service
    end

    def custom_fields
      API::V2::Desk::CustomField
    end

    def staff_members
      API::V2::Desk::StaffMember
    end

    def invoices
      API::V2::Desk::Invoice
    end

    def plan_products
      API::V2::Desk::PlanProduct
    end

    def plans
      API::V2::Desk::Plan
    end

    def revenue_categories
      API::V2::Desk::RevenueCategory
    end

    def sales_taxes
      API::V2::Desk::SalesTax
    end

    def bookings
      API::V2::Desk::Booking
    end

    def packs
      API::V2::Desk::Pack
    end

    def pack_products
      API::V2::Desk::PackProduct
    end

    def punches
      API::V2::Desk::Punch
    end

    def waitlist_entries
      API::V2::Desk::WaitlistEntry
    end

    def payments
      API::V2::Desk::Payment
    end

    def refunds
      API::V2::Desk::Refund
    end

    def make_ups
      API::V2::Desk::MakeUp
    end
  end
end
