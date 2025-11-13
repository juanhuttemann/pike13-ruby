# Pike13 Ruby Client

[![CI](https://github.com/juanhuttemann/pike13-ruby/actions/workflows/ci.yml/badge.svg)](https://github.com/juanhuttemann/pike13-ruby/actions/workflows/ci.yml)

A Ruby gem for interacting with the Pike13 API, supporting both:
- **[Core API](https://developer.pike13.com/docs/api/v2)** - CRUD operations for managing people, events, invoices, and more
- **[Reporting API](https://developer.pike13.com/docs/reporting/v3)** - Advanced analytics and reporting queries

## Installation

Add to your Gemfile:

```ruby
gem 'pike13'
```

Or install directly:

```bash
gem install pike13
```

## Configuration

```ruby
require 'pike13'

# Global configuration (recommended)
Pike13.configure do |config|
  config.access_token = "your_access_token"
  config.base_url = "yourbusiness.pike13.com"
end
```

## Usage

The gem supports two API versions with different capabilities:

### Core API - CRUD Operations

Three namespaces for managing your business data:

- **Account** (`Pike13::Account`) - Account-level operations (not scoped to a business)
- **Desk** (`Pike13::Desk`) - Staff interface operations (full read/write access)
- **Front** (`Pike13::Front`) - Client interface operations (limited access for customer-facing apps)

### Reporting API - Analytics & Insights

- **Reporting** (`Pike13::Reporting`) - Advanced query-based analytics with 12 comprehensive reporting endpoints

## Table of Contents

- [Account Resources](#account-resources)
- [Desk Resources](#desk-resources)
  - [People](#people)
  - [Business](#business)
  - [Events & Event Occurrences](#events--event-occurrences)
  - [Appointments](#appointments)
  - [Bookings](#bookings)
  - [Visits](#visits)
  - [Locations, Services, Staff](#locations-services-staff)
  - [Plans & Products](#plans--products)
  - [Invoices & Payments](#invoices--payments)
  - [Financial Settings](#financial-settings)
  - [Notes](#notes)
  - [Make-Ups](#make-ups)
  - [Waitlist](#waitlist)
  - [Custom Fields](#custom-fields)
  - [Person-Related Resources](#person-related-resources)
- [Front Resources](#front-resources)
  - [Business & Branding](#business--branding)
  - [People](#people-1)
  - [Events & Event Occurrences](#events--event-occurrences-1)
  - [Appointments](#appointments-1)
  - [Bookings](#bookings-1)
  - [Visits](#visits-1)
  - [Locations, Services, Staff](#locations-services-staff-1)
  - [Plans & Products](#plans--products-1)
  - [Invoices & Payments](#invoices--payments-1)
  - [Notes](#notes-1)
  - [Waitlist](#waitlist-1)
  - [Person-Related Resources](#person-related-resources-1)
- [Reporting Resources](#reporting-resources)
  - [Monthly Business Metrics](#monthly-business-metrics)
  - [Clients](#clients)
  - [Transactions](#transactions)
  - [Invoices](#invoices-1)
  - [Enrollments](#enrollments)
  - [Event Occurrences](#event-occurrences)
  - [Event Occurrence Staff Members](#event-occurrence-staff-members)
  - [Invoice Items](#invoice-items)
  - [Invoice Item Transactions](#invoice-item-transactions)
  - [Pays](#pays)
  - [Person Plans](#person-plans)
  - [Staff Members](#staff-members)
- [Error Handling](#error-handling)
- [Development](#development)
- [License](#license)

### Account Resources

Account-level operations for managing your Pike13 account.

```ruby
Pike13::Account.me                    # Get current account
Pike13::Account::Business.all         # List all businesses
Pike13::Account::Person.all           # Get all people
Pike13::Account::Password.create(email: "user@example.com")  # Password reset
Pike13::Account::Confirmation.create(confirmation_token: "token")  # Email confirmation
```

### Desk Resources

Full staff interface with read/write access to all resources.

#### People

```ruby
Pike13::Desk::Person.all                    # List all people
Pike13::Desk::Person.find(123)              # Find a person
Pike13::Desk::Person.me                     # Get authenticated user
Pike13::Desk::Person.search("john")         # Search people
Pike13::Desk::Person.create(first_name: "John", last_name: "Doe", email: "john@example.com")
Pike13::Desk::Person.update(123, first_name: "Jane")
Pike13::Desk::Person.destroy(123)
```

#### Business

```ruby
# Get business details
Pike13::Desk::Business.find

# Get franchisees (for franchise businesses)
Pike13::Desk::Business.franchisees
```

#### Events & Event Occurrences

```ruby
Pike13::Desk::Event.all                                    # List events
Pike13::Desk::Event.find(100)                             # Find event
Pike13::Desk::EventOccurrence.all(from: "2025-01-01", to: "2025-01-31")
Pike13::Desk::EventOccurrence.find(789)                   # Find occurrence
Pike13::Desk::EventOccurrence.summary                     # Get occurrence summary
Pike13::Desk::EventOccurrence.enrollment_eligibilities(id: 789)

# Event occurrence notes
Pike13::Desk::EventOccurrenceNote.all(event_occurrence_id: 789)
Pike13::Desk::EventOccurrenceNote.create(event_occurrence_id: 789, attributes: { note: "This is a note", subject: "Note Subject" })
Pike13::Desk::EventOccurrenceNote.update(event_occurrence_id: 789, id: 1, attributes: { note: "Updated note" })
Pike13::Desk::EventOccurrenceNote.destroy(event_occurrence_id: 789, id: 1)

# Visits and waitlist
Pike13::Desk::EventOccurrenceVisit.all(event_occurrence_id: 789)
Pike13::Desk::EventOccurrenceWaitlistEntry.all(event_occurrence_id: 789)
```

#### Appointments

```ruby
# Find available slots
Pike13::Desk::Appointment.find_available_slots(
  service_id: 100,
  date: "2025-01-15",
  location_ids: [1, 2],
  staff_member_ids: [3, 4]
)

# Get availability summary
Pike13::Desk::Appointment.available_slots_summary(
  service_id: 100,
  from: "2025-01-01",
  to: "2025-01-31",
  location_ids: [1, 2],
  staff_member_ids: [3, 4]
)
```

#### Bookings

**Note:** Creating bookings requires an `idempotency_token` parameter to prevent duplicate bookings.

```ruby
# Booking operations
Pike13::Desk::Booking.find(123)
Pike13::Desk::Booking.create(event_occurrence_id: 789, person_id: 123, idempotency_token: SecureRandom.uuid)
Pike13::Desk::Booking.update(456, state: "completed")
Pike13::Desk::Booking.destroy(456)

# Lease management within bookings
Pike13::Desk::Booking.find_lease(booking_id: 123, id: 456)
Pike13::Desk::Booking.create_lease(123, event_occurrence_id: 789, person: { id: 1 })
Pike13::Desk::Booking.update_lease(123, 456, person: { id: 2 })
Pike13::Desk::Booking.destroy_lease(123, 456)
```

#### Visits

```ruby
Pike13::Desk::Visit.all                     # List all visits
Pike13::Desk::Visit.find(456)              # Find visit
Pike13::Desk::Visit.summary(person_id: 123) # Get visit summary for a person
```

#### Locations, Services, Staff

```ruby
# Locations
Pike13::Desk::Location.all
Pike13::Desk::Location.find(1)

# Services
Pike13::Desk::Service.all
Pike13::Desk::Service.find(100)
Pike13::Desk::Service.enrollment_eligibilities(service_id: 100)

# Staff Members
Pike13::Desk::StaffMember.all
Pike13::Desk::StaffMember.find(5)
Pike13::Desk::StaffMember.me
```

#### Plans & Products

```ruby
Pike13::Desk::Plan.all                      # Plans
Pike13::Desk::Plan.find(200)
Pike13::Desk::PlanProduct.all               # Plan Products
Pike13::Desk::PlanProduct.find(300)
Pike13::Desk::PackProduct.all               # Pack Products
Pike13::Desk::PackProduct.find(400)
Pike13::Desk::Pack.find(500)                # Packs (find only)
Pike13::Desk::Punch.find(600)               # Punches (find only)
```

#### Invoices & Payments

```ruby
Pike13::Desk::Invoice.all                   # Invoices
Pike13::Desk::Invoice.find(700)
Pike13::Desk::Payment.find(800)             # Payments
Pike13::Desk::Payment.configuration
Pike13::Desk::Payment.void(payment_id: 800, invoice_item_ids_to_cancel: [1, 2])
Pike13::Desk::Refund.find(900)              # Refunds
Pike13::Desk::Refund.void(refund_id: 900)
```

#### Financial Settings

```ruby
Pike13::Desk::RevenueCategory.all           # Revenue Categories
Pike13::Desk::RevenueCategory.find(10)
Pike13::Desk::SalesTax.all                  # Sales Taxes
Pike13::Desk::SalesTax.find(20)
```

#### Notes

```ruby
Pike13::Desk::Note.all(person_id: 123)                    # List notes for a person
Pike13::Desk::Note.find(person_id: 123, id: 1000)        # Find note
Pike13::Desk::Note.create(person_id: 123, attributes: { note: "This is a note", subject: "Note Subject" })
Pike13::Desk::Note.update(person_id: 123, id: 1000, attributes: { note: "Updated note" })
Pike13::Desk::Note.destroy(person_id: 123, id: 1000)
```

#### Make-Ups

```ruby
Pike13::Desk::MakeUp.reasons                                # List make-up reasons
Pike13::Desk::MakeUp.generate(visit_id: 456, make_up_reason_id: 5, free_form_reason: "Client was sick")
```

#### Waitlist

```ruby
Pike13::Desk::WaitlistEntry.all             # List waitlist entries
Pike13::Desk::WaitlistEntry.find(1200)      # Find waitlist entry
```

#### Custom Fields

```ruby
Pike13::Desk::CustomField.all               # List custom fields
Pike13::Desk::CustomField.find(30)          # Find custom field
```

#### Person-Related Resources

```ruby
Pike13::Desk::PersonVisit.all(person_id: 123)               # List person's visits
Pike13::Desk::PersonPlan.all(person_id: 123)                # List person's plans
Pike13::Desk::PersonWaitlistEntry.all(person_id: 123)       # List person's waitlist entries
Pike13::Desk::PersonWaiver.all(person_id: 123)              # List person's waivers
Pike13::Desk::FormOfPayment.all(person_id: 123)             # List person's forms of payment
Pike13::Desk::FormOfPayment.find(person_id: 123, id: 456)   # Find form of payment
Pike13::Desk::FormOfPayment.create(person_id: 123, attributes: { type: "creditcard", token: "tok_xxx" })
Pike13::Desk::FormOfPayment.update(person_id: 123, id: 456, attributes: { is_default: true })
Pike13::Desk::FormOfPayment.destroy(person_id: 123, id: 456)
```

### Front Resources

Client-facing interface with limited read-only access.

#### Business & Branding

```ruby
Pike13::Front::Business.find                  # Get business info
Pike13::Front::Business.franchisees           # Get franchisees (for franchise businesses)
Pike13::Front::Branding.find                  # Get branding
```

#### People

```ruby
Pike13::Front::Person.me                      # Get authenticated client user (only)
```

#### Events & Event Occurrences

```ruby
Pike13::Front::Event.all                                    # List events
Pike13::Front::Event.find(100)                             # Find event
Pike13::Front::EventOccurrence.all(from: "2025-01-01", to: "2025-01-31")
Pike13::Front::EventOccurrence.find(789)                   # Find occurrence
Pike13::Front::EventOccurrence.summary                     # Get occurrence summary
Pike13::Front::EventOccurrence.enrollment_eligibilities(id: 789)
Pike13::Front::EventOccurrenceNote.all(event_occurrence_id: 789)
Pike13::Front::EventOccurrenceNote.find(event_occurrence_id: 789, id: 1)
Pike13::Front::EventOccurrenceWaitlistEligibility.all(event_occurrence_id: 789)
```

#### Appointments

```ruby
Pike13::Front::Appointment.find_available_slots(service_id: 100, date: "2025-01-15", location_ids: [1, 2], staff_member_ids: [3, 4])
Pike13::Front::Appointment.available_slots_summary(service_id: 100, from: "2025-01-01", to: "2025-01-31", location_ids: [1, 2], staff_member_ids: [3, 4])
```

#### Bookings

**Note:** Creating bookings requires an `idempotency_token` parameter to prevent duplicate bookings.

```ruby
# Booking operations
Pike13::Front::Booking.find(123)
Pike13::Front::Booking.create(event_occurrence_id: 789, person_id: 123, idempotency_token: SecureRandom.uuid)
Pike13::Front::Booking.update(456, state: "completed")
Pike13::Front::Booking.destroy(456)

# Lease management within bookings
Pike13::Front::Booking.find_lease(booking_id: 123, id: 456)
Pike13::Front::Booking.create_lease(123, event_occurrence_id: 789, person: { id: 1 })
Pike13::Front::Booking.update_lease(123, 456, person: { id: 2 })
Pike13::Front::Booking.destroy_lease(123, 456)
```

#### Visits

```ruby
Pike13::Front::Visit.all                      # List visits
Pike13::Front::Visit.find(456)               # Find visit
```

#### Locations, Services, Staff

```ruby
# Locations
Pike13::Front::Location.all
Pike13::Front::Location.find(1)

# Services
Pike13::Front::Service.all
Pike13::Front::Service.find(100)
Pike13::Front::Service.enrollment_eligibilities(service_id: 100)

# Staff Members
Pike13::Front::StaffMember.all
Pike13::Front::StaffMember.find(5)
```

#### Plans & Products

```ruby
Pike13::Front::Plan.all                       # Plans
Pike13::Front::Plan.find(200)
Pike13::Front::PlanProduct.all                # Plan Products
Pike13::Front::PlanProduct.find(300)
Pike13::Front::PlanTerms.all(plan_id: 200)    # Plan Terms
Pike13::Front::PlanTerms.find(plan_id: 200, plan_terms_id: 1)
Pike13::Front::PlanTerms.complete(plan_id: 200, plan_terms_id: 1)
```

#### Invoices & Payments

```ruby
Pike13::Front::Invoice.find(700)              # Invoices (find only)
Pike13::Front::Payment.find(800)              # Payments
Pike13::Front::Payment.configuration
```

#### Notes

```ruby
Pike13::Front::Note.all(person_id: 123)       # List notes for a person
Pike13::Front::Note.find(person_id: 123, id: 1000)  # Find note
```

#### Waitlist

```ruby
Pike13::Front::WaitlistEntry.all              # List waitlist entries
Pike13::Front::WaitlistEntry.find(1200)       # Find waitlist entry
```

#### Person-Related Resources

```ruby
Pike13::Front::PersonVisit.all(person_id: 123)                # List person's visits
Pike13::Front::PersonPlan.all(person_id: 123)                 # List person's plans
Pike13::Front::PersonWaitlistEntry.all(person_id: 123)        # List person's waitlist entries
Pike13::Front::PersonWaiver.all(person_id: 123)               # List person's waivers
Pike13::Front::FormOfPayment.all(person_id: 123)              # List person's forms of payment
Pike13::Front::FormOfPayment.find(person_id: 123, id: 456)    # Find form of payment
Pike13::Front::FormOfPayment.find_me(id: 456)                 # Find form of payment for authenticated user
Pike13::Front::FormOfPayment.create(person_id: 123, attributes: { type: "creditcard", token: "tok_xxx" })
Pike13::Front::FormOfPayment.update(person_id: 123, id: 456, attributes: { is_default: true })
Pike13::Front::FormOfPayment.destroy(person_id: 123, id: 456)
```

### Reporting Resources

Advanced query-based analytics for business insights. The Reporting API uses a different architecture than the Core API - it's designed for complex analytical queries with filtering, grouping, sorting, and aggregation capabilities.

**Note:** The v3 Reporting API conforms to [JSON API 1.0](https://jsonapi.org/format/1.0/) specification and uses `application/vnd.api+json` content type.

**Available Reporting Endpoints:**
- **Monthly Business Metrics** - Monthly transaction amounts, members, and enrollments
- **Clients** - Client demographics, tenure, visits, and engagement
- **Transactions** - Payment transactions, methods, and processing details
- **Invoices** - Invoice amounts, states, and payment tracking
- **Enrollments** - Visit/enrollment details and attendance patterns
- **Person Plans** - Active plans, memberships, and usage tracking
- **Event Occurrences** - Scheduled events, capacity, and attendance
- **Event Occurrence Staff Members** - Staff assignments and event workload
- **Invoice Items** - Line-item details and revenue breakdown
- **Invoice Item Transactions** - Transaction-level payment and refund tracking
- **Pays** - Staff compensation, pay rates, and service hours
- **Staff Members** - Staff roster, tenure, roles, and event assignments

All reporting endpoints support:
- **Filtering** - Query specific subsets of data
- **Grouping** - Aggregate data by dimensions
- **Sorting** - Order results by any field
- **Pagination** - Handle large result sets efficiently

#### Monthly Business Metrics

Summary of monthly transaction amounts, members, and enrollments over the lifetime of your business.

```ruby
# Basic query - get specific fields for all months
Pike13::Reporting::MonthlyBusinessMetrics.query(
  fields: ['month_start_date', 'net_paid_amount', 'new_client_count', 'member_count']
)

# Query with date range filter
Pike13::Reporting::MonthlyBusinessMetrics.query(
  fields: ['month_start_date', 'net_paid_amount', 'completed_enrollment_count'],
  filter: ['btw', 'month_start_date', '2024-01-01', '2024-12-31']
)

# Query with sorting (descending by date)
Pike13::Reporting::MonthlyBusinessMetrics.query(
  fields: ['month_start_date', 'net_paid_revenue_amount', 'first_visit_count'],
  sort: ['month_start_date-']
)

# Query with grouping (summary fields required)
Pike13::Reporting::MonthlyBusinessMetrics.query(
  fields: ['total_net_paid_amount', 'total_new_client_count', 'avg_member_count'],
  group: 'year_start_date'
)

# Query with pagination
Pike13::Reporting::MonthlyBusinessMetrics.query(
  fields: ['month_start_date', 'net_paid_amount'],
  page: { limit: 50 }
)

# Complex query with multiple filters
Pike13::Reporting::MonthlyBusinessMetrics.query(
  fields: [
    'month_start_date',
    'net_paid_revenue_amount',
    'new_client_count',
    'member_count',
    'completed_enrollment_count'
  ],
  filter: [
    'and',
    [
      ['btw', 'month_start_date', '2024-01-01', '2024-12-31'],
      ['gt', 'net_paid_amount', 0]
    ]
  ],
  sort: ['net_paid_amount-'],
  total_count: true
)
```

**Available Detail Fields** (when not grouping):
- Revenue: `net_paid_amount`, `net_paid_revenue_amount`, `payments_amount`, `refunds_amount`
- Clients: `new_client_count`, `member_count`, `client_w_plan_count`, `first_visit_count`
- Enrollments: `enrollment_count`, `completed_enrollment_count`, `completed_enrollment_per_client`
- Events: `event_occurrence_count`, `class_count`, `appointment_count`, `course_count`
- Plans: `pack_count`, `membership_count`, `prepaid_count`, `plan_start_count`, `plan_end_count`
- See `Pike13::Reporting::MonthlyBusinessMetrics::DETAIL_FIELDS` for the full list

**Available Summary Fields** (when grouping):
- `total_net_paid_amount`, `total_net_paid_revenue_amount`, `total_payments_amount`
- `total_new_client_count`, `avg_member_count`, `avg_client_w_plan_count`
- `total_enrollment_count`, `total_completed_enrollment_count`, `total_first_visit_count`
- See `Pike13::Reporting::MonthlyBusinessMetrics::SUMMARY_FIELDS` for the full list

**Available Groupings**:
- `business_id`, `business_name`, `business_subdomain`
- `currency_code`
- `quarter_start_date`, `year_start_date`

#### Clients

All client data — from tenure and unpaid bills to birthdays and passes held.

```ruby
# Basic query - get client contact information
Pike13::Reporting::Clients.query(
  fields: ['person_id', 'full_name', 'email', 'phone', 'client_since_date']
)

# Query for clients with memberships
Pike13::Reporting::Clients.query(
  fields: ['full_name', 'email', 'has_membership', 'tenure', 'completed_visits'],
  filter: ['eq', 'has_membership', true]
)

# Query for active clients with unpaid invoices
Pike13::Reporting::Clients.query(
  fields: ['full_name', 'email', 'last_invoice_amount', 'last_invoice_date'],
  filter: [
    'and',
    [
      ['eq', 'person_state', 'active'],
      ['eq', 'last_invoice_unpaid', true]
    ]
  ]
)

# Query for clients by tenure group
Pike13::Reporting::Clients.query(
  fields: ['full_name', 'email', 'tenure', 'tenure_group', 'completed_visits'],
  filter: ['eq', 'tenure_group', '5_over_three_years'],
  sort: ['completed_visits-']
)

# Group clients by tenure and count
Pike13::Reporting::Clients.query(
  fields: ['person_count', 'has_membership_count', 'total_completed_visits'],
  group: 'tenure_group'
)

# Search for clients by name
Pike13::Reporting::Clients.query(
  fields: ['person_id', 'full_name', 'email', 'phone'],
  filter: ['contains', 'full_name', 'Smith']
)
```

**Available Detail Fields** (when not grouping):
- Identity: `person_id`, `full_name`, `first_name`, `last_name`, `email`, `phone`
- Address: `street_address`, `street_address2`, `city`, `state_code`, `postal_code`, `country_code`
- Membership: `has_membership`, `current_plans`, `has_payment_on_file`, `has_plan_on_hold`
- Activity: `completed_visits`, `future_visits`, `unpaid_visits`, `last_visit_date`, `first_visit_date`
- Financial: `net_paid_amount`, `revenue_amount`, `account_credit_amount`, `last_invoice_amount`
- Tenure: `client_since_date`, `tenure`, `tenure_group`, `days_since_last_visit`
- Status: `person_state`, `is_schedulable`, `also_staff`, `has_signed_waiver`
- See `Pike13::Reporting::Clients::DETAIL_FIELDS` for the full list

**Available Summary Fields** (when grouping):
- `person_count`, `has_membership_count`, `has_payment_on_file_count`
- `total_completed_visits`, `total_future_visits`, `total_unpaid_visits`
- `total_net_paid_amount`, `total_revenue_amount`, `total_account_credit_amount`
- See `Pike13::Reporting::Clients::SUMMARY_FIELDS` for the full list

**Available Groupings**:
- Client attributes: `tenure_group`, `person_state`, `source_name`, `age`
- Location: `business_id`, `business_name`, `home_location_name`
- Dates: `client_since_date`, `client_since_month_start_date`, `client_since_quarter_start_date`, `client_since_year_start_date`
- Boolean flags: `has_membership`, `has_payment_on_file`, `is_schedulable`, `also_staff`

#### Transactions

Data about the money moving through your business.

```ruby
# Basic query - get recent transactions
Pike13::Reporting::Transactions.query(
  fields: ['transaction_id', 'transaction_date', 'net_paid_amount', 'payment_method', 'invoice_payer_name']
)

# Query transactions by date range
Pike13::Reporting::Transactions.query(
  fields: ['transaction_date', 'net_paid_amount', 'invoice_payer_name', 'payment_method'],
  filter: ['btw', 'transaction_date', '2024-01-01', '2024-12-31'],
  sort: ['transaction_date-']
)

# Query by payment method
Pike13::Reporting::Transactions.query(
  fields: ['transaction_date', 'net_paid_amount', 'invoice_payer_name'],
  filter: ['eq', 'payment_method', 'creditcard']
)

# Query failed transactions
Pike13::Reporting::Transactions.query(
  fields: ['transaction_date', 'transaction_amount', 'error_message', 'invoice_payer_name'],
  filter: ['eq', 'transaction_state', 'failed']
)

# Group by payment method
Pike13::Reporting::Transactions.query(
  fields: ['total_net_paid_amount', 'total_payments_amount', 'transaction_count'],
  group: 'payment_method'
)

# Group by month to see revenue trends
Pike13::Reporting::Transactions.query(
  fields: ['total_net_paid_amount', 'total_net_paid_revenue_amount', 'transaction_count'],
  group: 'transaction_month_start_date',
  sort: ['transaction_month_start_date']
)

# Detailed breakdown by card type
Pike13::Reporting::Transactions.query(
  fields: [
    'total_net_visa_paid_amount',
    'total_net_mastercard_paid_amount',
    'total_net_american_express_paid_amount',
    'total_net_discover_paid_amount'
  ],
  group: 'transaction_month_start_date'
)
```

**Available Detail Fields** (when not grouping):
- Transaction: `transaction_id`, `transaction_date`, `transaction_at`, `transaction_state`, `transaction_type`
- Amounts: `net_paid_amount`, `net_paid_revenue_amount`, `net_paid_tax_amount`, `payments_amount`, `refunds_amount`
- Payment: `payment_method`, `payment_method_detail`, `credit_card_name`, `processing_method`, `processor_transaction_id`
- Invoice: `invoice_id`, `invoice_number`, `invoice_state`, `invoice_due_date`, `invoice_autobill`
- Payer: `invoice_payer_id`, `invoice_payer_name`, `invoice_payer_email`, `invoice_payer_phone`
- Other: `created_by_name`, `commission_recipient_name`, `sale_location_name`, `error_message`
- See `Pike13::Reporting::Transactions::DETAIL_FIELDS` for the full list

**Available Summary Fields** (when grouping):
- Totals: `total_net_paid_amount`, `total_net_paid_revenue_amount`, `total_net_paid_tax_amount`
- Counts: `transaction_count`, `invoice_count`, `failed_count`, `settled_count`
- By payment method: `total_net_cash_paid_amount`, `total_net_check_paid_amount`, `total_net_credit_paid_amount`
- By card type: `total_net_visa_paid_amount`, `total_net_mastercard_paid_amount`, `total_net_american_express_paid_amount`, `total_net_discover_paid_amount`
- By processor: `total_net_amex_processing_paid_amount`, `total_net_global_pay_processing_paid_amount`
- See `Pike13::Reporting::Transactions::SUMMARY_FIELDS` for the full list

**Available Groupings**:
- Payment: `payment_method`, `credit_card_name`, `processing_method`, `external_payment_name`
- Dates: `transaction_date`, `transaction_month_start_date`, `transaction_quarter_start_date`, `transaction_year_start_date`
- Invoice: `invoice_id`, `invoice_number`, `invoice_state`, `invoice_payer_id`, `invoice_payer_name`
- States: `transaction_state`, `transaction_type`, `transaction_autopay`
- Location: `business_id`, `business_name`, `sale_location_name`

#### Invoices

Details of invoices, their status, revenue, and payment information.

```ruby
# Basic query - get all invoices
Pike13::Reporting::Invoices.query(
  fields: ['invoice_id', 'invoice_number', 'expected_amount', 'outstanding_amount', 'invoice_state']
)

# Query unpaid invoices
Pike13::Reporting::Invoices.query(
  fields: ['invoice_number', 'invoice_payer_name', 'outstanding_amount', 'invoice_due_date'],
  filter: ['gt', 'outstanding_amount', 0],
  sort: ['invoice_due_date']
)

# Query overdue invoices
Pike13::Reporting::Invoices.query(
  fields: ['invoice_number', 'invoice_payer_name', 'outstanding_amount', 'days_since_invoice_due'],
  filter: [
    'and',
    [
      ['eq', 'invoice_state', 'open'],
      ['gt', 'days_since_invoice_due', 0]
    ]
  ]
)

# Query by date range
Pike13::Reporting::Invoices.query(
  fields: ['invoice_number', 'expected_amount', 'net_paid_amount', 'invoice_payer_name'],
  filter: ['btw', 'issued_date', '2024-01-01', '2024-12-31']
)

# Group by invoice state
Pike13::Reporting::Invoices.query(
  fields: ['invoice_count', 'total_expected_amount', 'total_outstanding_amount'],
  group: 'invoice_state'
)

# Monthly revenue summary
Pike13::Reporting::Invoices.query(
  fields: ['total_expected_amount', 'total_net_paid_amount', 'total_outstanding_amount', 'invoice_count'],
  group: 'issued_month_start_date',
  sort: ['issued_month_start_date']
)

# Query with discounts and coupons
Pike13::Reporting::Invoices.query(
  fields: [
    'invoice_number',
    'gross_amount',
    'discounts_amount',
    'coupons_amount',
    'expected_amount'
  ],
  filter: ['gt', 'discounts_amount', 0]
)
```

**Available Detail Fields** (when not grouping):
- Invoice: `invoice_id`, `invoice_number`, `invoice_state`, `invoice_due_date`, `invoice_autobill`
- Amounts: `gross_amount`, `expected_amount`, `net_paid_amount`, `outstanding_amount`
- Revenue/Tax: `expected_revenue_amount`, `expected_tax_amount`, `net_paid_revenue_amount`, `net_paid_tax_amount`
- Adjustments: `discounts_amount`, `coupons_amount`, `adjustments_amount`
- Payments: `payments_amount`, `refunds_amount`, `failed_transactions`, `refunded_transactions`, `voided_transactions`
- Payer: `invoice_payer_id`, `invoice_payer_name`, `invoice_payer_email`, `invoice_payer_phone`
- Dates: `issued_date`, `issued_at`, `closed_date`, `closed_at`, `days_since_invoice_due`
- Other: `created_by_name`, `created_by_client`, `commission_recipient_name`, `sale_location_name`
- See `Pike13::Reporting::Invoices::DETAIL_FIELDS` for the full list

**Available Summary Fields** (when grouping):
- Counts: `invoice_count`, `created_by_client_count`, `invoice_autobill_count`
- Totals: `total_expected_amount`, `total_net_paid_amount`, `total_outstanding_amount`
- Revenue/Tax: `total_expected_revenue_amount`, `total_net_paid_revenue_amount`, `total_outstanding_revenue_amount`
- Adjustments: `total_discounts_amount`, `total_coupons_amount`, `total_adjustments_amount`
- See `Pike13::Reporting::Invoices::SUMMARY_FIELDS` for the full list

**Available Groupings**:
- State: `invoice_state`, `purchase_request_state`, `created_by_client`, `invoice_autobill`
- Dates: `issued_date`, `issued_month_start_date`, `closed_date`, `closed_month_start_date`, `invoice_due_date`
- Payer: `invoice_payer_id`, `invoice_payer_name`, `invoice_payer_home_location`
- Business: `business_id`, `business_name`, `sale_location_name`, `commission_recipient_name`

#### Enrollments

Data about visit and waitlist history, behavior, and trends.

```ruby
# Basic query - get visit details
Pike13::Reporting::Enrollments.query(
  fields: ['visit_id', 'full_name', 'service_name', 'state', 'service_date']
)

# Query completed visits
Pike13::Reporting::Enrollments.query(
  fields: ['full_name', 'service_name', 'service_date', 'estimated_amount', 'instructor_names'],
  filter: ['eq', 'state', 'completed'],
  sort: ['service_date-']
)

# Query by date range
Pike13::Reporting::Enrollments.query(
  fields: ['full_name', 'service_name', 'service_date', 'state'],
  filter: ['btw', 'service_date', '2024-01-01', '2024-12-31']
)

# Query first-time visitors
Pike13::Reporting::Enrollments.query(
  fields: ['full_name', 'email', 'service_name', 'service_date'],
  filter: ['eq', 'first_visit', true]
)

# Query unpaid visits
Pike13::Reporting::Enrollments.query(
  fields: ['full_name', 'service_name', 'service_date', 'available_plans'],
  filter: ['eq', 'is_paid', false]
)

# Group by service to analyze attendance
Pike13::Reporting::Enrollments.query(
  fields: ['completed_enrollment_count', 'noshowed_enrollment_count', 'total_visits_amount'],
  group: 'service_name'
)

# Group by day of week
Pike13::Reporting::Enrollments.query(
  fields: [
    'enrollment_count',
    'weekday_0_enrollment_count',
    'weekday_1_enrollment_count',
    'weekday_2_enrollment_count',
    'weekday_3_enrollment_count',
    'weekday_4_enrollment_count',
    'weekday_5_enrollment_count',
    'weekday_6_enrollment_count'
  ],
  group: 'service_month_start_date'
)

# Analyze client booking patterns
Pike13::Reporting::Enrollments.query(
  fields: ['enrollment_count', 'client_booked_count'],
  group: 'service_type'
)
```

**Available Detail Fields** (when not grouping):
- Visit: `visit_id`, `state`, `service_date`, `service_time`, `start_at`, `end_at`
- Person: `person_id`, `full_name`, `email`, `phone`, `birthdate`, `home_location_name`
- Service: `service_id`, `service_name`, `service_type`, `service_category`, `service_location_name`
- Event: `event_id`, `event_name`, `event_occurrence_id`, `instructor_names`
- Payment: `is_paid`, `estimated_amount`, `paid_with`, `paid_with_type`, `plan_id`, `punch_id`
- Status: `first_visit`, `client_booked`, `bulk_enrolled`, `is_waitlist`, `make_up_issued`
- Timing: `registered_at`, `completed_at`, `cancelled_at`, `noshow_at`, `waitlisted_at`, `cancelled_to_start`
- Duration: `duration_in_hours`, `duration_in_minutes`
- See `Pike13::Reporting::Enrollments::DETAIL_FIELDS` for the full list

**Available Summary Fields** (when grouping):
- Counts: `enrollment_count`, `visit_count`, `person_count`, `event_count`, `service_count`
- By state: `completed_enrollment_count`, `registered_enrollment_count`, `noshowed_enrollment_count`, `late_canceled_enrollment_count`
- Waitlist: `is_waitlist_count`, `waiting_enrollment_count`, `expired_enrollment_count`, `removed_enrollment_count`
- Payment: `is_paid_count`, `unpaid_visit_count`, `unpaid_visit_percent`, `total_visits_amount`, `avg_per_visit_amount`
- By day: `weekday_0_enrollment_count` through `weekday_6_enrollment_count` (Sunday through Saturday)
- Other: `first_visit_count`, `client_booked_count`, `consider_member_count`, `is_rollover_count`
- See `Pike13::Reporting::Enrollments::SUMMARY_FIELDS` for the full list

**Available Groupings**:
- Service: `service_id`, `service_name`, `service_type`, `service_category`, `service_location_name`
- Dates: `service_date`, `service_month_start_date`, `service_quarter_start_date`, `service_year_start_date`, `service_day`, `service_time`
- Event: `event_id`, `event_name`, `event_occurrence_id`, `instructor_names`
- Person: `person_id`, `full_name`, `home_location_name`, `primary_staff_name`
- Payment: `paid_with`, `paid_with_type`, `plan_id`, `punch_id`, `is_paid`
- Status: `state`, `first_visit`, `client_booked`, `is_waitlist`, `consider_member`
- Business: `business_id`, `business_name`, `business_subdomain`

#### Event Occurrences

Data about scheduled instances of services (e.g., "Group Workout from 9am-10am on 2024/09/01").

```ruby
# Basic query - get event occurrence details
Pike13::Reporting::EventOccurrences.query(
  fields: ['event_occurrence_id', 'event_name', 'service_date', 'enrollment_count', 'capacity']
)

# Query high-attendance classes
Pike13::Reporting::EventOccurrences.query(
  fields: ['event_name', 'service_date', 'service_time', 'completed_enrollment_count', 'capacity'],
  filter: ['gt', 'completed_enrollment_count', 15],
  sort: ['completed_enrollment_count-']
)

# Query classes with available spots
Pike13::Reporting::EventOccurrences.query(
  fields: ['event_name', 'service_date', 'enrollment_count', 'capacity', 'instructor_names'],
  filter: ['lt', 'enrollment_count', 'capacity']
)

# Query by date range and service type
Pike13::Reporting::EventOccurrences.query(
  fields: ['event_name', 'service_date', 'service_time', 'enrollment_count', 'service_type'],
  filter: [
    'and',
    [
      ['btw', 'service_date', '2024-01-01', '2024-12-31'],
      ['eq', 'service_type', 'group_class']
    ]
  ]
)

# Track attendance completion
Pike13::Reporting::EventOccurrences.query(
  fields: ['event_name', 'service_date', 'attendance_completed', 'completed_enrollment_count', 'noshowed_enrollment_count'],
  filter: ['eq', 'attendance_completed', true]
)

# Analyze no-shows and cancellations
Pike13::Reporting::EventOccurrences.query(
  fields: ['event_name', 'service_date', 'noshowed_enrollment_count', 'late_canceled_enrollment_count', 'enrollment_count']
)

# Group by service name to analyze performance
Pike13::Reporting::EventOccurrences.query(
  fields: ['total_enrollment_count', 'total_completed_enrollment_count', 'total_noshowed_enrollment_count', 'total_capacity'],
  group: 'service_name'
)

# Group by instructor to track performance
Pike13::Reporting::EventOccurrences.query(
  fields: ['event_occurrence_count', 'total_enrollment_count', 'total_completed_enrollment_count'],
  group: 'instructor_names'
)

# Monthly class summary
Pike13::Reporting::EventOccurrences.query(
  fields: ['event_occurrence_count', 'total_enrollment_count', 'total_duration_in_hours'],
  group: 'service_month_start_date'
)
```

**Available Detail Fields** (when not grouping):
- Event Occurrence: `event_occurrence_id`, `event_id`, `event_name`, `service_date`, `service_time`, `start_at`, `end_at`
- Capacity: `capacity`, `enrollment_count`, `visit_count`, `is_waitlist_count`, `waitlist_to_visit_count`
- Attendance: `attendance_completed`, `completed_enrollment_count`, `registered_enrollment_count`, `noshowed_enrollment_count`
- Enrollment states: `late_canceled_enrollment_count`, `expired_enrollment_count`, `removed_enrollment_count`, `reserved_enrollment_count`, `waiting_enrollment_count`
- Service: `service_id`, `service_name`, `service_type`, `service_category`, `service_location_name`, `service_state`
- Instructor: `instructor_names`
- Payment: `paid_count`, `completed_unpaid_count`
- Duration: `duration_in_hours`, `duration_in_minutes`
- See `Pike13::Reporting::EventOccurrences::DETAIL_FIELDS` for the full list

**Available Summary Fields** (when grouping):
- Counts: `event_occurrence_count`, `event_count`, `service_count`, `total_count`
- Capacity: `total_capacity`, `total_enrollment_count`, `total_visit_count`, `total_is_waitlist_count`
- Attendance: `attendance_completed_count`, `total_completed_enrollment_count`, `total_registered_enrollment_count`, `total_noshowed_enrollment_count`
- Enrollment states: `total_late_canceled_enrollment_count`, `total_expired_enrollment_count`, `total_removed_enrollment_count`, `total_reserved_enrollment_count`, `total_waiting_enrollment_count`
- Payment: `total_paid_count`, `total_completed_unpaid_count`
- Duration: `total_duration_in_hours`, `total_duration_in_minutes`
- Other: `total_waitlist_to_visit_count`
- See `Pike13::Reporting::EventOccurrences::SUMMARY_FIELDS` for the full list

**Available Groupings**:
- Event: `event_id`, `event_name`, `event_occurrence_id`, `instructor_names`
- Service: `service_id`, `service_name`, `service_type`, `service_category`, `service_location_name`, `service_state`
- Dates: `service_date`, `service_day`, `service_time`, `service_month_start_date`, `service_quarter_start_date`, `service_year_start_date`
- Week groupings: `service_week_mon_start_date`, `service_week_sun_start_date`
- Status: `attendance_completed`
- Business: `business_id`, `business_name`, `business_subdomain`

#### Event Occurrence Staff Members

Details of event occurrences by staff member (instructor, trainer, or organizer). If multiple staff members exist for an event occurrence, a record displays for each.

```ruby
# Basic query - get event occurrences by staff member
Pike13::Reporting::EventOccurrenceStaffMembers.query(
  fields: ['event_occurrence_id', 'full_name', 'event_name', 'service_date', 'enrollment_count']
)

# Query by specific staff member
Pike13::Reporting::EventOccurrenceStaffMembers.query(
  fields: ['full_name', 'event_name', 'service_date', 'service_time', 'completed_enrollment_count', 'role'],
  filter: ['eq', 'person_id', 12345],
  sort: ['service_date-']
)

# Query with staff contact information
Pike13::Reporting::EventOccurrenceStaffMembers.query(
  fields: ['full_name', 'email', 'phone', 'event_name', 'service_date', 'enrollment_count']
)

# Query by role and date range
Pike13::Reporting::EventOccurrenceStaffMembers.query(
  fields: ['full_name', 'role', 'event_name', 'service_date', 'completed_enrollment_count'],
  filter: [
    'and',
    [
      ['eq', 'role', 'owner'],
      ['btw', 'service_date', '2024-01-01', '2024-12-31']
    ]
  ]
)

# Track attendance completion by staff
Pike13::Reporting::EventOccurrenceStaffMembers.query(
  fields: ['full_name', 'event_name', 'service_date', 'attendance_completed', 'completed_enrollment_count', 'noshowed_enrollment_count']
)

# Analyze staff workload
Pike13::Reporting::EventOccurrenceStaffMembers.query(
  fields: ['full_name', 'event_name', 'service_date', 'duration_in_hours', 'enrollment_count', 'capacity']
)

# Group by staff member to analyze performance
Pike13::Reporting::EventOccurrenceStaffMembers.query(
  fields: ['event_occurrence_count', 'total_enrollment_count', 'total_completed_enrollment_count', 'total_duration_in_hours'],
  group: 'full_name'
)

# Group by service and staff
Pike13::Reporting::EventOccurrenceStaffMembers.query(
  fields: ['person_count', 'event_occurrence_count', 'total_enrollment_count'],
  group: 'service_name'
)

# Monthly summary by staff role
Pike13::Reporting::EventOccurrenceStaffMembers.query(
  fields: ['person_count', 'event_occurrence_count', 'total_duration_in_hours'],
  group: 'role'
)
```

**Available Detail Fields** (when not grouping):
- Staff Member: `person_id`, `full_name`, `email`, `phone`, `role`, `home_location_name`
- Address: `address`, `street_address`, `street_address2`, `city`, `state_code`, `postal_code`, `country_code`
- Event Occurrence: `event_occurrence_id`, `event_id`, `event_name`, `service_date`, `service_time`, `start_at`, `end_at`
- Capacity: `capacity`, `enrollment_count`, `visit_count`, `is_waitlist_count`, `waitlist_to_visit_count`
- Attendance: `attendance_completed`, `completed_enrollment_count`, `registered_enrollment_count`, `noshowed_enrollment_count`
- Enrollment states: `late_canceled_enrollment_count`, `expired_enrollment_count`, `removed_enrollment_count`, `reserved_enrollment_count`, `waiting_enrollment_count`
- Service: `service_id`, `service_name`, `service_type`, `service_category`, `service_location_name`, `service_state`
- Payment: `paid_count`, `completed_unpaid_count`
- Duration: `duration_in_hours`, `duration_in_minutes`
- See `Pike13::Reporting::EventOccurrenceStaffMembers::DETAIL_FIELDS` for the full list

**Available Summary Fields** (when grouping):
- Counts: `event_occurrence_count`, `event_count`, `service_count`, `person_count`, `total_count`
- Capacity: `total_capacity`, `total_enrollment_count`, `total_visit_count`, `total_is_waitlist_count`
- Attendance: `attendance_completed_count`, `total_completed_enrollment_count`, `total_registered_enrollment_count`, `total_noshowed_enrollment_count`
- Enrollment states: `total_late_canceled_enrollment_count`, `total_expired_enrollment_count`, `total_removed_enrollment_count`, `total_reserved_enrollment_count`, `total_waiting_enrollment_count`
- Payment: `total_paid_count`, `total_completed_unpaid_count`
- Duration: `total_duration_in_hours`, `total_duration_in_minutes`
- Other: `total_waitlist_to_visit_count`
- See `Pike13::Reporting::EventOccurrenceStaffMembers::SUMMARY_FIELDS` for the full list

**Available Groupings**:
- Staff: `person_id`, `full_name`, `role`
- Event: `event_id`, `event_name`, `event_occurrence_id`
- Service: `service_id`, `service_name`, `service_type`, `service_category`, `service_location_name`, `service_state`
- Dates: `service_date`, `service_day`, `service_time`, `service_month_start_date`, `service_quarter_start_date`, `service_year_start_date`
- Week groupings: `service_week_mon_start_date`, `service_week_sun_start_date`
- Status: `attendance_completed`
- Business: `business_id`, `business_name`, `business_subdomain`

#### Invoice Items

Item-level details of invoices.

```ruby
# Basic query - get invoice item details
Pike13::Reporting::InvoiceItems.query(
  fields: ['invoice_item_id', 'invoice_number', 'product_name', 'expected_amount', 'invoice_state']
)

# Query by product type
Pike13::Reporting::InvoiceItems.query(
  fields: ['product_name', 'product_type', 'expected_amount', 'net_paid_amount', 'outstanding_amount'],
  filter: ['eq', 'product_type', 'recurring']
)

# Query outstanding invoices
Pike13::Reporting::InvoiceItems.query(
  fields: ['invoice_number', 'invoice_payer_name', 'product_name', 'expected_amount', 'outstanding_amount'],
  filter: ['gt', 'outstanding_amount', 0],
  sort: ['outstanding_amount-']
)

# Query items with discounts
Pike13::Reporting::InvoiceItems.query(
  fields: ['product_name', 'gross_amount', 'discounts_amount', 'coupons_amount', 'expected_amount'],
  filter: ['gt', 'discounts_amount', 0]
)

# Track revenue by product
Pike13::Reporting::InvoiceItems.query(
  fields: ['product_name', 'gross_amount', 'expected_revenue_amount', 'expected_tax_amount', 'net_paid_revenue_amount']
)

# Query by revenue category
Pike13::Reporting::InvoiceItems.query(
  fields: ['revenue_category', 'product_name', 'expected_amount', 'net_paid_amount'],
  filter: ['not_null', 'revenue_category']
)

# Group by product to analyze sales
Pike13::Reporting::InvoiceItems.query(
  fields: ['invoice_item_count', 'total_expected_amount', 'total_net_paid_amount', 'total_outstanding_amount'],
  group: 'product_name'
)

# Group by product type
Pike13::Reporting::InvoiceItems.query(
  fields: ['invoice_item_count', 'total_gross_amount', 'total_discounts_amount', 'total_expected_amount'],
  group: 'product_type'
)

# Monthly revenue analysis
Pike13::Reporting::InvoiceItems.query(
  fields: ['invoice_item_count', 'total_expected_revenue_amount', 'total_net_paid_revenue_amount'],
  group: 'issued_month_start_date'
)
```

**Available Detail Fields** (when not grouping):
- Invoice Item: `invoice_item_id`, `invoice_id`, `invoice_number`, `invoice_state`, `invoice_autobill`
- Product: `product_id`, `product_name`, `product_name_at_sale`, `product_type`, `grants_membership`
- Amounts: `gross_amount`, `expected_amount`, `expected_revenue_amount`, `expected_tax_amount`
- Discounts: `discounts_amount`, `coupons_amount`, `coupon_code`, `adjustments_amount`, `discount_type`
- Payments: `net_paid_amount`, `net_paid_revenue_amount`, `net_paid_tax_amount`, `payments_amount`, `refunds_amount`
- Outstanding: `outstanding_amount`, `outstanding_revenue_amount`, `outstanding_tax_amount`
- Payer: `invoice_payer_id`, `invoice_payer_name`, `invoice_payer_email`, `invoice_payer_phone`, `invoice_payer_home_location`
- Dates: `issued_at`, `issued_date`, `closed_at`, `closed_date`, `invoice_due_date`, `days_since_invoice_due`
- Tax: `tax_types`, `tax_types_extended`
- Commission: `commission_recipient_name`
- Recipients: `recipient_names`
- Transactions: `failed_transactions`, `refunded_transactions`, `voided_transactions`
- Purchase Requests: `purchase_order_number`, `purchase_request_state`, `purchase_request_message`, `purchase_request_cancel_reason`
- Retail: `retail_options`, `retail_add_ons`
- Other: `revenue_category`, `sale_location_name`, `plan_id`, `created_by_client`, `created_by_name`
- See `Pike13::Reporting::InvoiceItems::DETAIL_FIELDS` for the full list

**Available Summary Fields** (when grouping):
- Counts: `invoice_item_count`, `invoice_count`, `grants_membership_count`, `total_count`
- Amounts: `total_gross_amount`, `total_expected_amount`, `total_expected_revenue_amount`, `total_expected_tax_amount`
- Discounts: `total_discounts_amount`, `total_coupons_amount`, `total_adjustments_amount`
- Payments: `total_net_paid_amount`, `total_net_paid_revenue_amount`, `total_net_paid_tax_amount`, `total_payments_amount`, `total_refunds_amount`
- Outstanding: `total_outstanding_amount`, `total_outstanding_revenue_amount`, `total_outstanding_tax_amount`
- See `Pike13::Reporting::InvoiceItems::SUMMARY_FIELDS` for the full list

**Available Groupings**:
- Product: `product_id`, `product_name`, `product_name_at_sale`, `product_type`, `grants_membership`, `plan_id`
- Invoice: `invoice_id`, `invoice_number`, `invoice_state`, `invoice_autobill`, `invoice_due_date`
- Payer: `invoice_payer_id`, `invoice_payer_name`, `invoice_payer_home_location`, `invoice_payer_primary_staff_name_at_sale`
- Dates - Issued: `issued_date`, `issued_month_start_date`, `issued_quarter_start_date`, `issued_year_start_date`
- Dates - Due: `due_month_start_date`, `due_quarter_start_date`, `due_year_start_date`
- Dates - Closed: `closed_date`, `closed_month_start_date`, `closed_quarter_start_date`, `closed_year_start_date`
- Week groupings: `issued_week_mon_start_date`, `issued_week_sun_start_date`, `due_week_mon_start_date`, `due_week_sun_start_date`, `closed_week_mon_start_date`, `closed_week_sun_start_date`
- Discounts: `discount_type`, `coupon_code`
- Other: `revenue_category`, `sale_location_name`, `commission_recipient_name`, `created_by_client`, `created_by_name`, `purchase_request_state`
- Business: `business_id`, `business_name`, `business_subdomain`

#### Invoice Item Transactions

Item-level details of transactions (payments and refunds). Payments and refunds are performed against the invoice, not the invoice item.

```ruby
# Basic query - get transaction details
Pike13::Reporting::InvoiceItemTransactions.query(
  fields: ['transaction_id', 'invoice_number', 'transaction_type', 'transaction_amount', 'transaction_state']
)

# Query by payment method
Pike13::Reporting::InvoiceItemTransactions.query(
  fields: ['transaction_date', 'payment_method', 'transaction_amount', 'invoice_payer_name', 'product_name'],
  filter: ['eq', 'payment_method', 'creditcard']
)

# Query successful payments
Pike13::Reporting::InvoiceItemTransactions.query(
  fields: ['transaction_date', 'invoice_number', 'payment_method', 'net_paid_amount', 'payment_method_detail'],
  filter: [
    'and',
    [
      ['eq', 'transaction_type', 'payment'],
      ['eq', 'transaction_state', 'settled']
    ]
  ]
)

# Query failed transactions
Pike13::Reporting::InvoiceItemTransactions.query(
  fields: ['failed_date', 'invoice_payer_name', 'payment_method', 'transaction_amount', 'error_message'],
  filter: ['eq', 'transaction_state', 'failed'],
  sort: ['failed_date-']
)

# Track refunds
Pike13::Reporting::InvoiceItemTransactions.query(
  fields: ['transaction_date', 'invoice_number', 'refunds_amount', 'invoice_payer_name', 'payment_transaction_id'],
  filter: ['eq', 'transaction_type', 'refund']
)

# Analyze revenue by product
Pike13::Reporting::InvoiceItemTransactions.query(
  fields: ['product_name', 'transaction_amount', 'net_paid_revenue_amount', 'net_paid_tax_amount', 'payment_method']
)

# Group by payment method to analyze payment trends
Pike13::Reporting::InvoiceItemTransactions.query(
  fields: ['transaction_count', 'total_net_paid_amount', 'settled_count', 'failed_count'],
  group: 'payment_method'
)

# Group by credit card type
Pike13::Reporting::InvoiceItemTransactions.query(
  fields: ['transaction_count', 'total_net_visa_paid_amount', 'total_net_mastercard_paid_amount', 'total_net_american_express_paid_amount', 'total_net_discover_paid_amount'],
  group: 'credit_card_name'
)

# Monthly transaction summary
Pike13::Reporting::InvoiceItemTransactions.query(
  fields: ['transaction_count', 'total_payments_amount', 'total_refunds_amount', 'total_net_paid_revenue_amount'],
  group: 'transaction_month_start_date'
)
```

**Available Detail Fields** (when not grouping):
- Transaction: `transaction_id`, `transaction_type`, `transaction_state`, `transaction_amount`, `transaction_at`, `transaction_date`, `transaction_autopay`
- Payment Info: `payment_method`, `payment_method_detail`, `processing_method`, `processor_transaction_id`, `credit_card_name`, `external_payment_name`
- Amounts: `net_paid_amount`, `net_paid_revenue_amount`, `net_paid_tax_amount`, `payments_amount`, `refunds_amount`
- Invoice: `invoice_id`, `invoice_number`, `invoice_state`, `invoice_autobill`, `invoice_due_date`, `invoice_item_id`
- Payer: `invoice_payer_id`, `invoice_payer_name`, `invoice_payer_email`, `invoice_payer_phone`, `invoice_payer_home_location`
- Product: `product_id`, `product_name`, `product_name_at_sale`, `product_type`, `grants_membership`, `plan_id`
- Failed: `failed_at`, `failed_date`, `error_message`
- Voided: `voided_at`
- Refund: `payment_transaction_id` (original payment for refund)
- Other: `revenue_category`, `sale_location_name`, `commission_recipient_name`, `created_by_name`
- See `Pike13::Reporting::InvoiceItemTransactions::DETAIL_FIELDS` for the full list

**Available Summary Fields** (when grouping):
- Counts: `transaction_count`, `settled_count`, `failed_count`, `transaction_autopay_count`, `invoice_count`, `invoice_item_count`, `grants_membership_count`, `total_count`
- Amounts: `total_net_paid_amount`, `total_net_paid_revenue_amount`, `total_net_paid_tax_amount`, `total_payments_amount`, `total_refunds_amount`
- By Payment Method: `total_net_cash_paid_amount`, `total_net_check_paid_amount`, `total_net_credit_paid_amount`, `total_net_ach_paid_amount`, `total_net_external_paid_amount`
- By Card Type: `total_net_visa_paid_amount`, `total_net_mastercard_paid_amount`, `total_net_american_express_paid_amount`, `total_net_discover_paid_amount`, `total_net_other_credit_card_paid_amount`
- By Processing Method: `total_net_amex_processing_paid_amount`, `total_net_global_pay_processing_paid_amount`, `total_net_other_processing_paid_amount`
- See `Pike13::Reporting::InvoiceItemTransactions::SUMMARY_FIELDS` for the full list

**Available Groupings**:
- Transaction: `transaction_id`, `transaction_type`, `transaction_state`, `transaction_autopay`, `transaction_date`
- Dates - Transaction: `transaction_month_start_date`, `transaction_quarter_start_date`, `transaction_year_start_date`
- Dates - Failed: `failed_date`, `failed_month_start_date`, `failed_quarter_start_date`, `failed_year_start_date`
- Week groupings: `transaction_week_mon_start_date`, `transaction_week_sun_start_date`, `failed_week_mon_start_date`, `failed_week_sun_start_date`
- Payment: `payment_method`, `processing_method`, `credit_card_name`, `external_payment_name`
- Invoice: `invoice_id`, `invoice_number`, `invoice_state`, `invoice_autobill`, `invoice_due_date`, `invoice_item_id`
- Payer: `invoice_payer_id`, `invoice_payer_name`, `invoice_payer_home_location`, `invoice_payer_primary_staff_name_at_sale`
- Product: `product_id`, `product_name`, `product_name_at_sale`, `product_type`, `grants_membership`, `plan_id`
- Other: `revenue_category`, `sale_location_name`, `commission_recipient_name`, `created_by_name`
- Business: `business_id`, `business_name`, `business_subdomain`

#### Pays

Details of staff member pay, pay rates, services, and hours.

```ruby
# Basic query - get pay details
Pike13::Reporting::Pays.query(
  fields: ['pay_id', 'staff_name', 'pay_type', 'final_pay_amount', 'pay_state']
)

# Query by staff member
Pike13::Reporting::Pays.query(
  fields: ['staff_name', 'service_name', 'service_date', 'final_pay_amount', 'service_hours'],
  filter: ['eq', 'staff_id', 12345],
  sort: ['service_date-']
)

# Query pending pay approvals
Pike13::Reporting::Pays.query(
  fields: ['staff_name', 'pay_description', 'final_pay_amount', 'pay_recorded_at'],
  filter: ['eq', 'pay_state', 'pending']
)

# Track pay by service type
Pike13::Reporting::Pays.query(
  fields: ['service_name', 'service_type', 'staff_name', 'base_pay_amount', 'per_head_pay_amount', 'tiered_pay_amount', 'final_pay_amount']
)

# Query by pay period
Pike13::Reporting::Pays.query(
  fields: ['staff_name', 'service_date', 'final_pay_amount', 'pay_period_start_date', 'pay_period_end_date'],
  filter: ['eq', 'pay_period', '2024-10-01..2024-10-31']
)

# Analyze pay by type
Pike13::Reporting::Pays.query(
  fields: ['pay_type', 'pay_description', 'final_pay_amount', 'staff_name'],
  filter: ['in', 'pay_type', ['service', 'commission', 'tip']]
)

# Group by staff member to analyze total pay
Pike13::Reporting::Pays.query(
  fields: ['pay_count', 'total_final_pay_amount', 'total_service_hours', 'total_base_pay_amount'],
  group: 'staff_name'
)

# Group by service to analyze pay distribution
Pike13::Reporting::Pays.query(
  fields: ['service_count', 'pay_count', 'total_final_pay_amount'],
  group: 'service_name'
)

# Group by pay type
Pike13::Reporting::Pays.query(
  fields: ['pay_count', 'total_final_pay_amount', 'total_base_pay_amount', 'total_per_head_pay_amount', 'total_tiered_pay_amount'],
  group: 'pay_type'
)
```

**Available Detail Fields** (when not grouping):
- Pay: `pay_id`, `pay_type`, `pay_state`, `pay_description`, `pay_period`, `pay_period_start_date`, `pay_period_end_date`
- Amounts: `final_pay_amount`, `base_pay_amount`, `per_head_pay_amount`, `tiered_pay_amount`
- Staff: `staff_id`, `staff_name`, `staff_home_location_name`
- Service: `service_id`, `service_name`, `service_type`, `service_category`, `service_date`, `service_location_name`, `service_hours`
- Recorded: `pay_recorded_at`
- Reviewed: `pay_reviewed_at`, `pay_reviewed_date`, `pay_reviewed_by_id`, `pay_reviewed_by_name`
- Other: `revenue_category`
- See `Pike13::Reporting::Pays::DETAIL_FIELDS` for the full list

**Available Summary Fields** (when grouping):
- Counts: `pay_count`, `service_count`, `total_count`
- Amounts: `total_final_pay_amount`, `total_base_pay_amount`, `total_per_head_pay_amount`, `total_tiered_pay_amount`
- Hours: `total_service_hours`
- See `Pike13::Reporting::Pays::SUMMARY_FIELDS` for the full list

**Available Groupings**:
- Pay: `pay_type`, `pay_state`, `pay_period`, `pay_reviewed_date`, `pay_reviewed_by_id`, `pay_reviewed_by_name`
- Staff: `staff_id`, `staff_name`, `staff_home_location_name`
- Service: `service_id`, `service_name`, `service_type`, `service_category`, `service_date`, `service_location_name`
- Other: `revenue_category`
- Business: `business_id`, `business_name`, `business_subdomain`

#### Person Plans

Comprehensive data about passes and plans that are available for use or on hold.

```ruby
# Basic query - get all person plans
Pike13::Reporting::PersonPlans.query(
  fields: ['person_plan_id', 'full_name', 'plan_name', 'is_available', 'start_date', 'end_date']
)

# Query available memberships
Pike13::Reporting::PersonPlans.query(
  fields: ['full_name', 'plan_name', 'start_date', 'end_date', 'remaining_visit_count'],
  filter: [
    'and',
    [
      ['eq', 'is_available', true],
      ['eq', 'grants_membership', true]
    ]
  ]
)

# Query plans on hold
Pike13::Reporting::PersonPlans.query(
  fields: ['full_name', 'plan_name', 'last_hold_start_date', 'last_hold_end_date', 'last_hold_by'],
  filter: ['eq', 'is_on_hold', true]
)

# Query plans with past due invoices
Pike13::Reporting::PersonPlans.query(
  fields: ['full_name', 'plan_name', 'latest_invoice_due_date', 'latest_invoice_item_amount'],
  filter: ['eq', 'latest_invoice_past_due', true]
)

# Track plan usage and visits
Pike13::Reporting::PersonPlans.query(
  fields: ['full_name', 'plan_name', 'used_visit_count', 'remaining_visit_count', 'lifetime_used_visit_count'],
  filter: ['gt', 'used_visit_count', 0]
)

# Group by plan type
Pike13::Reporting::PersonPlans.query(
  fields: ['person_plan_count', 'is_available_count', 'is_on_hold_count', 'is_canceled_count'],
  group: 'plan_type'
)

# Analyze plan retention
Pike13::Reporting::PersonPlans.query(
  fields: [
    'person_plan_count',
    'visited_count',
    'visited_percent',
    'next_plan_count',
    'next_plan_percent'
  ],
  group: 'plan_name'
)

# Track first-time members
Pike13::Reporting::PersonPlans.query(
  fields: ['full_name', 'plan_name', 'start_date', 'first_visit_date', 'start_date_to_first_visit'],
  filter: ['eq', 'is_first_plan', true]
)
```

**Available Detail Fields** (when not grouping):
- Plan: `person_plan_id`, `plan_id`, `plan_name`, `plan_type`, `plan_product_id`, `product_name`
- Person: `person_id`, `full_name`, `first_name`, `last_name`, `email`, `home_location_name`
- Dates: `start_date`, `end_date`, `last_usable_date`, `first_visit_date`, `last_visit_date`
- Status: `is_available`, `is_on_hold`, `is_canceled`, `is_exhausted`, `is_ended`, `is_deactivated`
- Visits: `allowed_visit_count`, `used_visit_count`, `remaining_visit_count`, `lifetime_used_visit_count`
- Membership: `grants_membership`, `is_first_membership`, `is_first_plan`
- Billing: `base_price`, `invoice_interval_count`, `invoice_interval_unit`, `commitment_length`
- Invoice: `latest_invoice_due_date`, `latest_invoice_item_amount`, `latest_invoice_past_due`, `latest_invoice_autobill`
- Hold: `last_hold_start_date`, `last_hold_end_date`, `last_hold_by`, `is_last_hold_indefinite`
- Next Plan: `next_plan_id`, `next_plan_name`, `next_plan_type`, `next_plan_start_date`
- Timing: `start_date_to_first_visit`, `first_visit_to_next_plan`, `last_visit_to_next_plan`
- See `Pike13::Reporting::PersonPlans::DETAIL_FIELDS` for the full list (100+ fields)

**Available Summary Fields** (when grouping):
- Counts: `person_plan_count`, `person_count`, `plan_count`, `visited_count`, `visited_percent`
- Availability: `is_available_count`, `is_on_hold_count`, `is_canceled_count`
- Membership: `grants_membership_count`, `is_first_membership_count`, `is_first_plan_count`
- Next Plan: `next_plan_count`, `next_plan_percent`, `next_plan_within_week_percent`
- Usage: `total_used_visit_count`, `total_lifetime_used_visit_count`
- Averages: `avg_start_date_to_first_visit`, `avg_first_visit_to_next_plan`, `avg_last_visit_to_next_plan`
- See `Pike13::Reporting::PersonPlans::SUMMARY_FIELDS` for the full list

**Available Groupings**:
- Plan: `plan_id`, `plan_name`, `plan_type`, `product_id`, `product_name`, `plan_location_name`
- Person: `person_id`, `full_name`, `home_location_name`, `primary_staff_name`
- Status: `is_available`, `is_on_hold`, `is_canceled`, `grants_membership`, `is_first_plan`
- Dates: `start_date`, `start_month_start_date`, `first_visit_date`, `first_visit_month_start_date`, `last_visit_date`
- Invoice: `latest_invoice_past_due`, `latest_invoice_autobill`, `latest_invoice_due_date`
- Business: `business_id`, `business_name`, `business_subdomain`, `revenue_category`

#### Staff Members

All staff member data — from tenure and events to birthdays and custom fields. Includes all staff members past and present.

```ruby
# Basic query - get all staff members
Pike13::Reporting::StaffMembers.query(
  fields: ['person_id', 'full_name', 'email', 'role', 'person_state']
)

# Query active staff members with event counts
Pike13::Reporting::StaffMembers.query(
  fields: ['full_name', 'email', 'role', 'tenure', 'future_events', 'past_events'],
  filter: ['eq', 'person_state', 'active'],
  sort: ['tenure-']
)

# Find staff members shown to clients
Pike13::Reporting::StaffMembers.query(
  fields: ['full_name', 'email', 'role', 'home_location_name'],
  filter: ['eq', 'show_to_clients', true]
)

# Query staff members by role
Pike13::Reporting::StaffMembers.query(
  fields: ['full_name', 'email', 'tenure', 'future_events'],
  filter: ['in', 'role', ['manager', 'owner', 'primary_owner']]
)

# Find staff with upcoming birthdays
Pike13::Reporting::StaffMembers.query(
  fields: ['full_name', 'email', 'birthdate', 'days_until_birthday'],
  filter: ['lte', 'days_until_birthday', 30],
  sort: ['days_until_birthday+']
)

# Track staff tenure
Pike13::Reporting::StaffMembers.query(
  fields: ['full_name', 'staff_since_date', 'tenure', 'tenure_group', 'past_events'],
  filter: ['eq', 'person_state', 'active'],
  sort: ['tenure-']
)

# Find staff who are also clients
Pike13::Reporting::StaffMembers.query(
  fields: ['full_name', 'email', 'role', 'home_location_name'],
  filter: ['eq', 'also_client', true]
)

# Group by role to analyze staff composition
Pike13::Reporting::StaffMembers.query(
  fields: ['person_count', 'total_future_events', 'total_past_events'],
  group: 'role'
)

# Group by tenure group to analyze staff retention
Pike13::Reporting::StaffMembers.query(
  fields: ['person_count', 'total_future_events', 'also_client_count'],
  group: 'tenure_group'
)

# Group by location to see staff distribution
Pike13::Reporting::StaffMembers.query(
  fields: ['person_count', 'total_future_events', 'total_past_events'],
  group: 'home_location_name'
)
```

**Available Detail Fields** (when not grouping):
- Person: `person_id`, `full_name`, `first_name`, `last_name`, `middle_name`, `email`, `phone`, `birthdate`, `age`, `days_until_birthday`
- Address: `address`, `street_address`, `street_address2`, `city`, `state_code`, `postal_code`, `country_code`
- Staff: `role`, `person_state`, `show_to_clients`, `also_client`, `home_location_id`, `home_location_name`
- Tenure: `staff_since_date`, `tenure`, `tenure_group`
- Events: `future_events`, `past_events`, `attendance_not_completed_events`
- Custom: `custom_fields`
- See `Pike13::Reporting::StaffMembers::DETAIL_FIELDS` for the full list

**Available Summary Fields** (when grouping):
- Counts: `person_count`, `also_client_count`, `demoted_staff_count`, `total_count`
- Events: `total_future_events`, `total_past_events`, `total_attendance_not_completed_events`
- See `Pike13::Reporting::StaffMembers::SUMMARY_FIELDS` for the full list

**Available Groupings**:
- Staff: `role`, `person_state`, `show_to_clients`, `also_client`, `home_location_name`
- Tenure: `staff_since_date`, `staff_since_month_start_date`, `staff_since_quarter_start_date`, `staff_since_week_mon_start_date`, `staff_since_week_sun_start_date`, `staff_since_year_start_date`, `tenure_group`
- Demographics: `age`
- Business: `business_id`, `business_name`, `business_subdomain`

## Error Handling

```ruby
begin
  person = Pike13::Desk::Person.find(999999)
rescue Pike13::AuthenticationError => e
  # 401 Unauthorized
  puts "Authentication failed: #{e.message}"
rescue Pike13::NotFoundError => e
  # 404 Not Found
  puts "Resource not found: #{e.message}"
rescue Pike13::ValidationError => e
  # 422 Unprocessable Entity
  puts "Validation failed: #{e.message}"
rescue Pike13::RateLimitError => e
  # 429 Too Many Requests
  puts "Rate limit exceeded. Retry after: #{e.rate_limit_reset}"
rescue Pike13::ServerError => e
  # 5xx Server Error
  puts "Server error: #{e.message}"
rescue Pike13::APIError => e
  # Other API errors
  puts "API error: #{e.message}"
end
```

## Development

```bash
# Install dependencies
bundle install

# Run tests
bundle exec rake test
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

[MIT License](LICENSE.txt)

## Links

- **[Pike13 Core API Documentation](https://developer.pike13.com/docs/api/v2)** - Core API (v2) endpoints
- **[Pike13 Reporting API Documentation](https://developer.pike13.com/docs/reporting/v3)** - Reporting API (v3) endpoints
- **[Pike13 Website](https://www.pike13.com/)** - Official website
