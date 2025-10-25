# frozen_string_literal: true

module Pike13
  # Front API resources (client interface)
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
  class FrontResources
    def initialize(client)
      @client = client
    end

    def appointments
      API::V2::Front::Appointment
    end

    def business
      API::V2::Front::Business
    end

    def branding
      API::V2::Front::Branding
    end

    def people
      API::V2::Front::Person
    end

    def events
      API::V2::Front::Event
    end

    def event_occurrences
      API::V2::Front::EventOccurrence
    end

    def locations
      API::V2::Front::Location
    end

    def services
      API::V2::Front::Service
    end

    def staff_members
      API::V2::Front::StaffMember
    end

    def visits
      API::V2::Front::Visit
    end

    def invoices
      API::V2::Front::Invoice
    end

    def plans
      API::V2::Front::Plan
    end

    def plan_products
      API::V2::Front::PlanProduct
    end

    def bookings
      API::V2::Front::Booking
    end

    def waitlist_entries
      API::V2::Front::WaitlistEntry
    end

    def payments
      API::V2::Front::Payment
    end
  end
end
