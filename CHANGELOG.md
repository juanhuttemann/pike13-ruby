# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2025-01-27

### Added

#### Core Infrastructure
- HTTP client with Faraday and automatic retry (max 2 retries, exponential backoff)
- Bearer token authentication
- Automatic JSON response parsing
- Global configuration management via `Pike13.configure`
- URL validation supporting HTTP/HTTPS schemes and custom ports
- Support for production (`mybiz.pike13.com`) and development (`http://mybiz.pike13.test:3000`) environments

#### Error Handling
- `Pike13::Error` - Base error class
- `Pike13::ConfigurationError` - Configuration validation errors
- `Pike13::APIError` - Base for HTTP errors
- `Pike13::AuthenticationError` (401)
- `Pike13::NotFoundError` (404)
- `Pike13::ValidationError` (422)
- `Pike13::RateLimitError` (429) with rate limit reset header tracking
- `Pike13::ServerError` (5xx)

#### Account Scope Resources
Base URL: `https://pike13.com/api/v2`

- **Account::Me** - Get current account details
- **Account::Business** - List and find businesses
- **Account::Person** - List and find people
- **Account::Password** - Password reset/creation
- **Account::Confirmation** - Email confirmation

#### Desk Scope Resources (Staff Interface)
Base URL: `https://[base_url]/api/v2`

**People Management:**
- **Desk::Person** - Full CRUD operations
  - List all people, find by ID, search, get authenticated user
  - Create, update, and delete people

**Business & Locations:**
- **Desk::Business** - Get business information
- **Desk::Location** - List and find locations

**Events & Scheduling:**
- **Desk::Event** - List and find events
- **Desk::EventOccurrence** - List and find occurrences, summaries, enrollment eligibility
- **Desk::Appointment** - Find available slots and availability summaries

**Bookings & Visits:**
- **Desk::Booking** - Full CRUD operations for bookings
- **Desk::Visit** - List and find visits, get visit summaries

**Services & Staff:**
- **Desk::Service** - List and find services, enrollment eligibility
- **Desk::StaffMember** - List and find staff members, get authenticated staff

**Plans & Products:**
- **Desk::Plan** - List and find plans
- **Desk::PlanProduct** - List and find plan products
- **Desk::PackProduct** - List and find pack products
- **Desk::Pack** - Find packs by ID
- **Desk::Punch** - Find punches by ID

**Financial:**
- **Desk::Invoice** - List and find invoices
- **Desk::Payment** - Find payments, void payments, get payment configuration
- **Desk::Refund** - Find refunds, void refunds
- **Desk::RevenueCategory** - List and find revenue categories
- **Desk::SalesTax** - List and find sales taxes

**Notes & Communication:**
- **Desk::Note** - Full CRUD operations for person notes
  - List notes for a person
  - Create, update, and delete notes

**Other Resources:**
- **Desk::MakeUp** - Find make-ups, list reasons, generate make-up credits
- **Desk::WaitlistEntry** - List and find waitlist entries
- **Desk::CustomField** - List and find custom fields

#### Front Scope Resources (Client Interface)
Base URL: `https://[base_url]/api/v2`

**Business & Branding:**
- **Front::Business** - Get business information
- **Front::Branding** - Get branding information

**People:**
- **Front::Person** - Get authenticated client user only

**Events & Scheduling:**
- **Front::Event** - List and find events
- **Front::EventOccurrence** - List and find occurrences, summaries, enrollment eligibility
- **Front::Appointment** - Find available slots and availability summaries

**Bookings & Visits:**
- **Front::Booking** - Full CRUD operations, find leases
- **Front::Visit** - List and find visits

**Services & Staff:**
- **Front::Service** - List and find services, enrollment eligibility
- **Front::StaffMember** - List and find staff members
- **Front::Location** - List and find locations

**Plans & Products:**
- **Front::Plan** - List and find plans
- **Front::PlanProduct** - List and find plan products

**Financial:**
- **Front::Invoice** - Find invoices by ID
- **Front::Payment** - Find payments, get payment configuration

**Other Resources:**
- **Front::Note** - List and find person notes (read-only)
- **Front::WaitlistEntry** - List and find waitlist entries

### Dependencies
- `faraday` (~> 2.0) - HTTP client
- `faraday-retry` (~> 2.0) - Automatic retry middleware
- Ruby >= 3.0.0 required

### Development
- RuboCop configuration for code quality
- Minitest test suite with 99 tests, 93% line coverage
- SimpleCov for test coverage reporting
