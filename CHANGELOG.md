# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2025-10-31

Initial release with complete Pike13 API support.

### Added

#### Core Infrastructure
- HTTP client with HTTParty and automatic error handling
- Bearer token authentication with configurable base URLs
- Global configuration management with URL normalization
- Comprehensive error handling with specific HTTP status mappings
- Support for both production and development environments

#### API v2 - Core API
**Account Resources:**
- Account management and business listing
- Person management across businesses
- Password reset functionality
- Email confirmation system

**Desk Resources (Staff Interface):**
- Person CRUD operations with search functionality
- Business and location management
- Event and event occurrence scheduling
- Appointment availability and slot management
- Booking system with lease support
- Visit tracking and summaries
- Service management with enrollment eligibility
- Staff member management
- Plan, pack, and product management
- Invoice and payment processing
- Revenue category and sales tax management
- Note system for person records
- Make-up credit management
- Waitlist entry management
- Custom field support

**Front Resources (Client Interface):**
- Business and branding information
- Authenticated user access
- Event browsing and enrollment eligibility
- Appointment booking with lease support
- Payment method management
- Read-only access to appropriate resources

#### API v3 - Reporting API
Complete reporting analytics with 12 endpoints:
- Monthly business metrics
- Client demographics and engagement analysis
- Transaction records with payment breakdowns
- Invoice tracking and revenue analysis
- Enrollment and attendance patterns
- Event occurrence analytics
- Staff workload and assignment tracking
- Invoice item details
- Transaction-level payment/refund tracking
- Staff compensation data
- Client plan ownership metrics
- Complete staff roster management

#### Technical Features
- Ruby >= 3.0.0 compatibility
- Faraday HTTP client with retry middleware
- Comprehensive test coverage (93% line coverage)
- RuboCop code quality enforcement
- SimpleCov coverage reporting

### Dependencies
- `httparty` (~> 0.21) - HTTP client library
- Ruby >= 3.0.0 required

### Development
- Minitest test suite with 300+ test methods
- SimpleCov for coverage reporting
- RuboCop for code quality
- GitHub Actions CI/CD ready