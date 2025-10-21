# Changelog

## [Unreleased]

## [0.1.0-beta] - Unreleased

### Added

#### Core Infrastructure
- HTTP client with Faraday and automatic retry (max 2 retries, exponential backoff)
- Connection pooling for different base URLs (account vs scoped endpoints)
- Bearer token authentication
- Automatic JSON response parsing
- Configuration management (global and per-client)
  - `Pike13::Configuration` with `access_token` and `base_url`
  - URL validation supporting HTTP/HTTPS schemes and custom ports
  - Support for production (`mybiz.pike13.com`) and development (`http://mybiz.pike13.test:3000`) environments
- Comprehensive error handling with specific exception classes:
  - `Pike13::Error` (base)
  - `Pike13::ConfigurationError`
  - `Pike13::APIError` (base for HTTP errors)
  - `Pike13::AuthenticationError` (401)
  - `Pike13::NotFoundError` (404)
  - `Pike13::ValidationError` (422)
  - `Pike13::RateLimitError` (429) with rate limit reset header tracking
  - `Pike13::ServerError` (5xx)

#### API Resource Architecture
- `Pike13::API::V2::Base` - Base class for all resources
  - Standard CRUD operations: `find(id)`, `all()`, `count()`
  - Automatic attribute mapping and accessor generation
  - `reload()` method for refreshing resource data
  - `has_many` DSL for nested resource relationships
- `Pike13::API::V2::SingularResource` - For singleton resources (Business, Branding)
  - `find(id)` without ID requirement
  - Raises `NotImplementedError` for `all()` and `count()`
- `Pike13::API::V2::FindOnlyResource` - For ID-only resources
  - Only supports `find(id)`
  - Raises `NotImplementedError` for `all()` and `count()`
- `Pike13::API::V2::PersonMethods` - Mixin for Person resources
  - `me()` - Get authenticated user
  - `search(query)` - Search people by query string
- `Pike13::API::V2::ResourceProxy` - Dynamic method delegation for client namespaces
- Resource inheritance patterns with automatic scope and resource name detection

#### Account Scope Resources
**Base URL:** `https://pike13.com/api/v2`

- **Account::Account** (Singular)
  - `client.account.me` - Get current account details
  - Custom implementation with `/account` endpoint

- **Account::Business** (Collection)
  - `client.account.businesses.all` - List all businesses
  - `client.account.businesses.find(id)` - Find specific business
  - `client.account.businesses.count` - Get total count
  - Custom implementation using `/account/people` endpoint

- **Account::Person** (Collection)
  - `client.account.people.all` - List all people
  - `client.account.people.find(id)` - Find specific person
  - `client.account.people.count` - Get total count
  - Custom implementation using `/account/people` endpoint
  - **NOTE:** Does not include `PersonMethods` - no `.me()` or `.search()` available

#### Desk Scope Resources (Staff Interface)
**Base URL:** `https://[base_url]/api/v2`

- **Desk::Appointment** (Utility Class)
  - `client.desk.appointments.find_available_slots(service_id:, date:, location_ids:, staff_member_ids:)` - Find available appointment slots
  - `client.desk.appointments.available_slots_summary(service_id:, from:, to:, location_ids:, staff_member_ids:)` - Get availability heat map (90-day limit)

- **Desk::Business** (Singular)
  - `client.desk.business.find` - Get business information
  - `client.desk.business.franchisees` - Get franchisee list

- **Desk::Person** (Collection with PersonMethods)
  - `client.desk.people.all` - List all people
  - `client.desk.people.find(id)` - Find specific person
  - `client.desk.people.count` - Get total count
  - `client.desk.people.me` - Get authenticated staff member
  - `client.desk.people.search(query)` - Search people
  - Nested resources via `has_many`: `plans`, `waivers`, `form_of_payments`, `notes`, `waitlist_entries`
  - Custom visits method: `person.visits` (uses Visit.all with person_id)

- **Desk::Visit** (Collection with Custom Scoping)
  - `client.desk.visits.find(id)` - Find specific visit
  - `client.desk.visits.all(person_id:)` - List visits for person (required)
  - `client.desk.visits.count` - Get total count
  - Custom nested path when person_id provided: `/desk/people/{person_id}/visits`

- **Desk::Event** (Collection)
  - `client.desk.events.all` - List all events
  - `client.desk.events.find(id)` - Find specific event
  - `client.desk.events.count` - Get total count

- **Desk::EventOccurrence** (Collection with Custom Methods)
  - `client.desk.event_occurrences.all` - List all event occurrences
  - `client.desk.event_occurrences.find(id)` - Find specific occurrence
  - `client.desk.event_occurrences.count` - Get total count
  - `client.desk.event_occurrences.summary` - Get occurrence summaries
  - `client.desk.event_occurrences.enrollment_eligibilities(id:)` - Get enrollment eligibilities
  - Nested resources via `has_many`: `waitlist_entries`

- **Desk::Location** (Collection)
  - `client.desk.locations.all` - List all locations
  - `client.desk.locations.find(id)` - Find specific location
  - `client.desk.locations.count` - Get total count

- **Desk::Service** (Collection with Custom Methods)
  - `client.desk.services.all` - List all services
  - `client.desk.services.find(id)` - Find specific service
  - `client.desk.services.count` - Get total count
  - `client.desk.services.enrollment_eligibilities(service_id:)` - Get enrollment eligibilities

- **Desk::CustomField** (Collection)
  - `client.desk.custom_fields.all` - List all custom fields
  - `client.desk.custom_fields.find(id)` - Find specific custom field
  - `client.desk.custom_fields.count` - Get total count

- **Desk::StaffMember** (Collection with Custom Methods)
  - `client.desk.staff_members.all` - List all staff members
  - `client.desk.staff_members.find(id)` - Find specific staff member
  - `client.desk.staff_members.count` - Get total count
  - `client.desk.staff_members.me` - Get authenticated staff member

- **Desk::Invoice** (Collection with Nested Resources)
  - `client.desk.invoices.all` - List all invoices
  - `client.desk.invoices.find(id)` - Find specific invoice
  - `client.desk.invoices.count` - Get total count
  - Nested resources via `has_many`: `payment_methods`

- **Desk::PlanProduct** (Collection)
  - `client.desk.plan_products.all` - List all plan products
  - `client.desk.plan_products.find(id)` - Find specific plan product
  - `client.desk.plan_products.count` - Get total count

- **Desk::Plan** (Collection)
  - `client.desk.plans.all` - List all plans
  - `client.desk.plans.find(id)` - Find specific plan
  - `client.desk.plans.count` - Get total count

- **Desk::RevenueCategory** (Collection)
  - `client.desk.revenue_categories.all` - List all revenue categories
  - `client.desk.revenue_categories.find(id)` - Find specific revenue category
  - `client.desk.revenue_categories.count` - Get total count

- **Desk::SalesTax** (Collection)
  - `client.desk.sales_taxes.all` - List all sales taxes
  - `client.desk.sales_taxes.find(id)` - Find specific sales tax
  - `client.desk.sales_taxes.count` - Get total count

- **Desk::WaitlistEntry** (Collection)
  - `client.desk.waitlist_entries.all` - List all waitlist entries
  - `client.desk.waitlist_entries.find(id)` - Find specific waitlist entry
  - `client.desk.waitlist_entries.count` - Get total count

- **Desk::PackProduct** (Collection)
  - `client.desk.pack_products.all` - List all pack products
  - `client.desk.pack_products.find(id)` - Find specific pack product
  - `client.desk.pack_products.count` - Get total count

**Find-Only Resources (Desk):**
- **Desk::Booking** - `client.desk.bookings.find(id)` only
- **Desk::Pack** - `client.desk.packs.find(id)` only
- **Desk::Punch** - `client.desk.punches.find(id)` only

#### Front Scope Resources (Client Interface)
**Base URL:** `https://[base_url]/api/v2`

- **Front::Appointment** (Utility Class)
  - `client.front.appointments.find_available_slots(service_id:, date:, location_ids:, staff_member_ids:)` - Find available appointment slots
  - `client.front.appointments.available_slots_summary(service_id:, from:, to:, location_ids:, staff_member_ids:)` - Get availability heat map (90-day limit)

- **Front::Business** (Singular)
  - `client.front.business.find` - Get business information

- **Front::Branding** (Singular)
  - `client.front.branding.find` - Get branding information

- **Front::Person** (Restricted Collection with PersonMethods)
  - `client.front.people.me` - Get authenticated client user
  - `client.front.people.find(id)` - Find specific person (if authorized)
  - **RESTRICTION:** `all()` and `count()` raise `NotImplementedError` - Front API only provides authenticated user access
  - Nested resources via `has_many`: `visits`, `waitlist_entries`

- **Front::Event** (Collection)
  - `client.front.events.all` - List all events
  - `client.front.events.find(id)` - Find specific event
  - `client.front.events.count` - Get total count

- **Front::EventOccurrence** (Collection with Custom Methods)
  - `client.front.event_occurrences.all` - List all event occurrences
  - `client.front.event_occurrences.find(id)` - Find specific occurrence
  - `client.front.event_occurrences.count` - Get total count
  - `client.front.event_occurrences.summary` - Get occurrence summaries
  - `client.front.event_occurrences.enrollment_eligibilities(id:)` - Get enrollment eligibilities

- **Front::Location** (Collection)
  - `client.front.locations.all` - List all locations
  - `client.front.locations.find(id)` - Find specific location
  - `client.front.locations.count` - Get total count

- **Front::Service** (Collection with Custom Methods)
  - `client.front.services.all` - List all services
  - `client.front.services.find(id)` - Find specific service
  - `client.front.services.count` - Get total count
  - `client.front.services.enrollment_eligibilities(service_id:)` - Get enrollment eligibilities

- **Front::StaffMember** (Collection)
  - `client.front.staff_members.all` - List all staff members
  - `client.front.staff_members.find(id)` - Find specific staff member
  - `client.front.staff_members.count` - Get total count

- **Front::Visit** (Collection)
  - `client.front.visits.all` - List all visits
  - `client.front.visits.find(id)` - Find specific visit
  - `client.front.visits.count` - Get total count

- **Front::Plan** (Collection with Custom Methods)
  - `client.front.plans.all` - List all plans
  - `client.front.plans.find(id)` - Find specific plan
  - `client.front.plans.count` - Get total count

- **Front::PlanProduct** (Collection)
  - `client.front.plan_products.all` - List all plan products
  - `client.front.plan_products.find(id)` - Find specific plan product
  - `client.front.plan_products.count` - Get total count

**Find-Only Resources (Front):**
- **Front::Booking** (with Custom Methods)
  - `client.front.bookings.find(id)` only
  - `client.front.bookings.find_lease(booking_id:, id:)` - Get specific lease for booking
- **Front::Invoice** (with Nested Resources)
  - `client.front.invoices.find(id)` only
  - Nested resources via `has_many`: `payment_methods`
- **Front::WaitlistEntry** - `client.front.waitlist_entries.find(id)` only

#### Client Architecture
- **Pike13::Client** - Main client class
  - Constructor accepts `access_token:` and `base_url:` parameters
  - Falls back to global `Pike13.configuration` if parameters not provided
  - Automatic configuration validation on initialization
  - Three namespace accessors: `account`, `desk`, `front`

- **Namespace Classes**
  - `Pike13::AccountNamespace` - Account-level resources
  - `Pike13::DeskNamespace` - Staff interface resources
  - `Pike13::FrontNamespace` - Client interface resources
  - Dynamic resource accessor methods using metaprogramming
  - Resource-to-class mapping via `RESOURCES` constants

#### Global Configuration
- Module-level configuration: `Pike13.configure { |config| ... }`
- Convenience constructor: `Pike13.new(access_token:, base_url:)`

#### Dependencies
- `faraday` (~> 2.0) - HTTP client
- `faraday-retry` (~> 2.0) - Automatic retry middleware
- Ruby >= 3.0.0 required

### Architecture Notes
- **Read-only operations only** - No create, update, or delete operations implemented
- Three distinct API scopes with different base URLs and access patterns
- Consistent resource patterns with base classes for different access types
- Automatic attribute mapping and dynamic method generation
- Built-in error handling and retry logic
- Support for both global and per-client configuration
- Nested resource relationships using `has_many` DSL
- Custom resource implementations for Pike13 API quirks (e.g., Visit scoping, Person search)

### API Limitations Handled
- Find-only resources explicitly raise `NotImplementedError` for unsupported operations
- Front::Person restricts listing operations (API design limitation)
- Visit resources require person_id scoping in most cases
- Proper error messages guide users to correct usage patterns

### Development
- RuboCop configuration for code quality
- Comprehensive YARD documentation
- Minitest-ready (test files referenced but not included in gem)
