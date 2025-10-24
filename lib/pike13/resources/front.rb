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
  class FrontResources < ResourceCollection
    register_resources(
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
    )
  end
end
