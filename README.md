# Pike13 Ruby Client

A Ruby gem for interacting with the [Pike13 Core API](https://developer.pike13.com/docs/api/v2).

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

The Pike13 API is organized into four namespaces:

- **Account** - Account-level operations (not scoped to a business)
- **Desk** - Staff interface operations (full access)
- **Front** - Client interface operations (limited access)
- **Reporting** - Advanced reporting queries (v3 API)

### Account Resources

Account-level resources for managing your Pike13 account.

```ruby
# Get current account
Pike13::Account.me

# List all businesses
Pike13::Account::Business.all

# Get all people
Pike13::Account::Person.all

# Password reset
Pike13::Account::Password.create(email: "user@example.com")

# Email confirmation
Pike13::Account::Confirmation.create(confirmation_token: "token")
```

### Desk Resources (Staff Interface)

Full staff interface with read/write access to all resources.

#### People

```ruby
# List all people
Pike13::Desk::Person.all

# Find a person
Pike13::Desk::Person.find(123)

# Get authenticated user
Pike13::Desk::Person.me

# Search people
Pike13::Desk::Person.search("john")

# Create a person
Pike13::Desk::Person.create(
  first_name: "John",
  last_name: "Doe",
  email: "john@example.com"
)

# Update a person
Pike13::Desk::Person.update(123, first_name: "Jane")

# Delete a person
Pike13::Desk::Person.destroy(123)
```

#### Business

```ruby
# Get business details
Pike13::Desk::Business.find
```

#### Events & Event Occurrences

```ruby
# List events
Pike13::Desk::Event.all

# Find event
Pike13::Desk::Event.find(100)

# List event occurrences
Pike13::Desk::EventOccurrence.all(from: "2025-01-01", to: "2025-01-31")

# Find occurrence
Pike13::Desk::EventOccurrence.find(789)

# Get occurrence summary
Pike13::Desk::EventOccurrence.summary

# Check enrollment eligibility
Pike13::Desk::EventOccurrence.enrollment_eligibilities(id: 789)

# List event occurrence notes
Pike13::Desk::EventOccurrenceNote.all(event_occurrence_id: 789)

# Find event occurrence note
Pike13::Desk::EventOccurrenceNote.find(event_occurrence_id: 789, id: 1)

# Create event occurrence note
Pike13::Desk::EventOccurrenceNote.create(
  event_occurrence_id: 789,
  attributes: {
    note: "This is a note",      # Use "note" not "body"
    subject: "Note Subject"       # Optional
  }
)

# Update event occurrence note
Pike13::Desk::EventOccurrenceNote.update(
  event_occurrence_id: 789,
  id: 1,
  attributes: {
    note: "Updated note",        # Use "note" not "body"
    subject: "Updated Subject"   # Optional
  }
)

# Delete event occurrence note
Pike13::Desk::EventOccurrenceNote.destroy(event_occurrence_id: 789, id: 1)

# List visits for an event occurrence
Pike13::Desk::EventOccurrenceVisit.all(event_occurrence_id: 789)

# List waitlist entries for an event occurrence
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
# Find booking
Pike13::Desk::Booking.find(123)

# Create booking (requires idempotency token)
Pike13::Desk::Booking.create(
  event_occurrence_id: 789,
  person_id: 123,
  idempotency_token: SecureRandom.uuid  # Required: unique token to prevent duplicates
)

# Update booking
Pike13::Desk::Booking.update(456, state: "completed")

# Delete booking
Pike13::Desk::Booking.destroy(456)
```

#### Visits

```ruby
# List all visits
Pike13::Desk::Visit.all

# Find visit
Pike13::Desk::Visit.find(456)

# Get visit summary for a person
Pike13::Desk::Visit.summary(person_id: 123)
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
# Plans
Pike13::Desk::Plan.all
Pike13::Desk::Plan.find(200)

# Plan Products
Pike13::Desk::PlanProduct.all
Pike13::Desk::PlanProduct.find(300)

# Pack Products
Pike13::Desk::PackProduct.all
Pike13::Desk::PackProduct.find(400)

# Packs (find only)
Pike13::Desk::Pack.find(500)

# Punches (find only)
Pike13::Desk::Punch.find(600)
```

#### Invoices & Payments

```ruby
# Invoices
Pike13::Desk::Invoice.all
Pike13::Desk::Invoice.find(700)

# Payments
Pike13::Desk::Payment.find(800)
Pike13::Desk::Payment.configuration
Pike13::Desk::Payment.void(payment_id: 800, invoice_item_ids_to_cancel: [1, 2])

# Refunds
Pike13::Desk::Refund.find(900)
Pike13::Desk::Refund.void(refund_id: 900)
```

#### Financial Settings

```ruby
# Revenue Categories
Pike13::Desk::RevenueCategory.all
Pike13::Desk::RevenueCategory.find(10)

# Sales Taxes
Pike13::Desk::SalesTax.all
Pike13::Desk::SalesTax.find(20)
```

#### Notes

```ruby
# List notes for a person
Pike13::Desk::Note.all(person_id: 123)

# Find note
Pike13::Desk::Note.find(person_id: 123, id: 1000)

# Create note
Pike13::Desk::Note.create(
  person_id: 123,
  attributes: {
    note: "This is a note",       # Use "note" not "body"
    subject: "Note Subject"        # Optional but recommended
  }
)

# Update note
Pike13::Desk::Note.update(
  person_id: 123,
  id: 1000,
  attributes: {
    note: "Updated note",          # Use "note" not "body"
    subject: "Updated Subject"     # Optional
  }
)

# Delete note
Pike13::Desk::Note.destroy(person_id: 123, id: 1000)
```

#### Make-Ups

```ruby
# Find make-up
Pike13::Desk::MakeUp.find(1100)

# List make-up reasons
Pike13::Desk::MakeUp.reasons

# Generate make-up credit
Pike13::Desk::MakeUp.generate(
  visit_id: 456,
  make_up_reason_id: 5,
  free_form_reason: "Client was sick"
)
```

#### Waitlist

```ruby
# List waitlist entries
Pike13::Desk::WaitlistEntry.all

# Find waitlist entry
Pike13::Desk::WaitlistEntry.find(1200)
```

#### Custom Fields

```ruby
# List custom fields
Pike13::Desk::CustomField.all

# Find custom field
Pike13::Desk::CustomField.find(30)
```

#### Person-Related Resources

```ruby
# List person's visits
Pike13::Desk::PersonVisit.all(person_id: 123)

# List person's plans
Pike13::Desk::PersonPlan.all(person_id: 123)

# List person's waitlist entries
Pike13::Desk::PersonWaitlistEntry.all(person_id: 123)

# List person's waivers
Pike13::Desk::PersonWaiver.all(person_id: 123)

# List person's forms of payment
Pike13::Desk::FormOfPayment.all(person_id: 123)

# Find form of payment
Pike13::Desk::FormOfPayment.find(person_id: 123, id: 456)

# Create form of payment
# Note: Requires 'type' parameter ("creditcard" for credit cards, "ach" for bank accounts)
Pike13::Desk::FormOfPayment.create(
  person_id: 123,
  attributes: {
    type: "creditcard",  # Required! Options: "creditcard" or "ach"
    token: "tok_xxx"
  }
)

# Update form of payment
Pike13::Desk::FormOfPayment.update(
  person_id: 123,
  id: 456,
  attributes: { is_default: true }
)

# Delete form of payment
Pike13::Desk::FormOfPayment.destroy(person_id: 123, id: 456)
```

### Front Resources (Client Interface)

Client-facing interface with limited read-only access.

#### Business & Branding

```ruby
# Get business info
Pike13::Front::Business.find

# Get branding
Pike13::Front::Branding.find
```

#### People

```ruby
# Get authenticated client user (only)
Pike13::Front::Person.me
```

#### Events & Event Occurrences

```ruby
# List events
Pike13::Front::Event.all

# Find event
Pike13::Front::Event.find(100)

# List event occurrences
Pike13::Front::EventOccurrence.all(from: "2025-01-01", to: "2025-01-31")

# Find occurrence
Pike13::Front::EventOccurrence.find(789)

# Get occurrence summary
Pike13::Front::EventOccurrence.summary

# Check enrollment eligibility
Pike13::Front::EventOccurrence.enrollment_eligibilities(id: 789)

# List event occurrence notes
Pike13::Front::EventOccurrenceNote.all(event_occurrence_id: 789)

# Find event occurrence note
Pike13::Front::EventOccurrenceNote.find(event_occurrence_id: 789, id: 1)

# List waitlist eligibilities for an event occurrence
Pike13::Front::EventOccurrenceWaitlistEligibility.all(event_occurrence_id: 789)
```

#### Appointments

```ruby
# Find available slots
Pike13::Front::Appointment.find_available_slots(
  service_id: 100,
  date: "2025-01-15",
  location_ids: [1, 2],
  staff_member_ids: [3, 4]
)

# Get availability summary
Pike13::Front::Appointment.available_slots_summary(
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
# Find booking
Pike13::Front::Booking.find(123)

# Find lease for booking
Pike13::Front::Booking.find_lease(booking_id: 123, id: 456)

# Create booking (requires idempotency token)
Pike13::Front::Booking.create(
  event_occurrence_id: 789,
  person_id: 123,
  idempotency_token: SecureRandom.uuid  # Required: unique token to prevent duplicates
)

# Update booking
Pike13::Front::Booking.update(456, state: "completed")

# Delete booking
Pike13::Front::Booking.destroy(456)
```

#### Visits

```ruby
# List visits
Pike13::Front::Visit.all

# Find visit
Pike13::Front::Visit.find(456)
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
# Plans
Pike13::Front::Plan.all
Pike13::Front::Plan.find(200)

# Plan Products
Pike13::Front::PlanProduct.all
Pike13::Front::PlanProduct.find(300)

# Plan Terms
Pike13::Front::PlanTerms.all(plan_id: 200)
Pike13::Front::PlanTerms.find(plan_id: 200, plan_terms_id: 1)
Pike13::Front::PlanTerms.complete(plan_id: 200, plan_terms_id: 1)
```

#### Invoices & Payments

```ruby
# Invoices (find only)
Pike13::Front::Invoice.find(700)

# Payments
Pike13::Front::Payment.find(800)
Pike13::Front::Payment.configuration
```

#### Notes

```ruby
# List notes for a person
Pike13::Front::Note.all(person_id: 123)

# Find note
Pike13::Front::Note.find(person_id: 123, id: 1000)
```

#### Waitlist

```ruby
# List waitlist entries
Pike13::Front::WaitlistEntry.all

# Find waitlist entry
Pike13::Front::WaitlistEntry.find(1200)
```

#### Person-Related Resources

```ruby
# List person's visits
Pike13::Front::PersonVisit.all(person_id: 123)

# List person's plans
Pike13::Front::PersonPlan.all(person_id: 123)

# List person's waitlist entries
Pike13::Front::PersonWaitlistEntry.all(person_id: 123)

# List person's waivers
Pike13::Front::PersonWaiver.all(person_id: 123)

# List person's forms of payment
Pike13::Front::FormOfPayment.all(person_id: 123)

# Find form of payment
Pike13::Front::FormOfPayment.find(person_id: 123, id: 456)

# Find form of payment for authenticated user
Pike13::Front::FormOfPayment.find_me(id: 456)

# Create form of payment
# Note: Requires 'type' parameter ("creditcard" for credit cards, "ach" for bank accounts)
Pike13::Front::FormOfPayment.create(
  person_id: 123,
  attributes: {
    type: "creditcard",  # Required! Options: "creditcard" or "ach"
    token: "tok_xxx"
  }
)

# Update form of payment
Pike13::Front::FormOfPayment.update(
  person_id: 123,
  id: 456,
  attributes: { is_default: true }
)

# Delete form of payment
Pike13::Front::FormOfPayment.destroy(person_id: 123, id: 456)
```

### Reporting Resources (v3 API)

Advanced reporting queries for business analytics and insights.

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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

MIT License

## Links

- [Pike13 API Documentation](https://developer.pike13.com/docs/api/v2)
- [Pike13 Website](https://www.pike13.com/)
