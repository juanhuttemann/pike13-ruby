# Pike13 Ruby Client

A Ruby gem for interacting with the [Pike13 Core API](https://developer.pike13.com/docs/api/v2).

## Installation

```ruby
gem 'pike13'
```

## Configuration

```ruby
require 'pike13'

# Direct instantiation
client = Pike13::Client.new(
  access_token: "your_access_token",
  base_url: "yourbusiness.pike13.com"
)

# Global configuration
Pike13.configure do |config|
  config.access_token = "your_access_token"
  config.base_url = "yourbusiness.pike13.com"
end

client = Pike13.new
```

## Usage

### Account Resources

```ruby
# List businesses
businesses = client.account.businesses.all

# Get current user
me = client.account.people.me
```

### Desk Resources (Staff Interface)

```ruby
# People
people = client.desk.people.all
person = client.desk.people.find(123)
results = client.desk.people.search("john")
me = client.desk.people.me

# Business (singular resource)
business = client.desk.business.find

# Events & Event Occurrences
events = client.desk.events.all
event = client.desk.events.find(100)
occurrences = client.desk.event_occurrences.all(from: "2025-01-01", to: "2025-01-31")
occurrence = client.desk.event_occurrences.find(789)

# Appointments
appointments = client.desk.appointments.all
appointment = client.desk.appointments.find(456)

# Visits
visits = client.desk.visits.all
visits = client.desk.visits.all(person_id: 123)  # Filter by person
visit = client.desk.visits.find(456)

# Locations, Services, Staff
locations = client.desk.locations.all
services = client.desk.services.all
staff_members = client.desk.staff_members.all

# Plans & Products
plans = client.desk.plans.all
plan_products = client.desk.plan_products.all
pack_products = client.desk.pack_products.all

# Invoices & Financials
invoices = client.desk.invoices.all
revenue_categories = client.desk.revenue_categories.all
sales_taxes = client.desk.sales_taxes.all

# Custom Fields
custom_fields = client.desk.custom_fields.all

# Waitlist
waitlist_entries = client.desk.waitlist_entries.all

# Find-only resources (no .all method)
booking = client.desk.bookings.find(123)
pack = client.desk.packs.find(456)
punch = client.desk.punches.find(789)
```

### Front Resources (Client Interface)

```ruby
# Business & Branding (singular resources)
business = client.front.business.find
branding = client.front.branding.find

# People (current user only)
me = client.front.people.me

# Events & Event Occurrences
events = client.front.events.all
event = client.front.events.find(100)
occurrences = client.front.event_occurrences.all(from: "2025-01-01", to: "2025-01-31")
occurrence = client.front.event_occurrences.find(789)

# Appointments
appointments = client.front.appointments.all
appointment = client.front.appointments.find(456)

# Visits
visits = client.front.visits.all
visit = client.front.visits.find(456)

# Locations, Services, Staff
locations = client.front.locations.all
services = client.front.services.all
staff_members = client.front.staff_members.all

# Plans & Products
plans = client.front.plans.all
plan_products = client.front.plan_products.all

# Find-only resources (no .all method)
booking = client.front.bookings.find(123)
invoice = client.front.invoices.find(456)
entry = client.front.waitlist_entries.find(789)
```

### Nested Resources

Access nested resources directly (single request):

```ruby
# Get visits for a person
visits = client.desk.visits.all(person_id: 123)
```

Or via parent object (makes two requests):

```ruby
person = client.desk.people.find(123)
visits = person.visits
plans = person.plans
waivers = person.waivers
form_of_payments = person.form_of_payments
notes = person.notes
```

## Error Handling

```ruby
begin
  person = client.desk.people.find(999999)
rescue Pike13::AuthenticationError => e
  # 401
rescue Pike13::NotFoundError => e
  # 404
rescue Pike13::ValidationError => e
  # 422
rescue Pike13::RateLimitError => e
  # 429
rescue Pike13::ServerError => e
  # 5xx
rescue Pike13::APIError => e
  # Other errors
end
```

## Development

```bash
bundle install
bundle exec rake test
bundle exec rubocop
```

## License

MIT License
