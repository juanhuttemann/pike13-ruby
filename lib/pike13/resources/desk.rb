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
  class DeskResources < ResourceCollection
    register_resources(
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
      waitlist_entries: API::V2::Desk::WaitlistEntry,
      payments: API::V2::Desk::Payment,
      refunds: API::V2::Desk::Refund,
      make_ups: API::V2::Desk::MakeUp
    )
  end
end
