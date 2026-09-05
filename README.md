# Inventory & Warehouse ERP

A multi-tenant inventory management and order-processing system built with
Ruby on Rails. Multiple companies (tenants) can each manage their own
products, warehouses, suppliers, and stock — with every stock change
recorded as an immutable ledger entry rather than a mutable "quantity"
field, so stock levels are always derived and auditable.

## Features

- **Multi-tenant** — each `Company` is fully isolated; users belong to
  exactly one company and only ever see that company's data.
- **Role-based access** — `viewer`, `staff`, and `admin` roles per user.
- **Product catalog** — SKUs, categories, unit pricing, and per-product
  reorder thresholds for low-stock alerts.
- **Warehouses & suppliers** — track stock across multiple physical
  locations and the suppliers you buy from.
- **Stock ledger** — every stock change (purchase receipt, sale, manual
  adjustment) is recorded as a `StockMovement`. Current stock on hand is
  computed by summing the ledger, never stored redundantly.
- **Purchase orders** — draft → order → receive workflow; receiving stock
  automatically generates the corresponding ledger entries.
- **Sales orders** — draft → confirm → fulfill workflow; fulfilling an
  order deducts stock via the same ledger mechanism.

## Tech stack

- Ruby 3.3+ / Rails 8
- SQLite (Rails 8 defaults — used for the primary DB as well as Solid
  Queue/Cache/Cable)
- Turbo & Stimulus (Hotwire) for interactivity, no separate JS build step
  (import maps)
- Session-based authentication via Rails 8's built-in `has_secure_password`
  authentication generator

## Prerequisites

You'll need Ruby 3.3+, Rails 8, and SQLite installed. The recommended way
to install Ruby is via a version manager (`rbenv`) rather than your OS's
system package:

**Install rbenv + ruby-build**, then a Ruby version:
```bash
# Arch / Garuda
sudo pacman -S rbenv

# Debian / Ubuntu
sudo apt install rbenv

# macOS
brew install rbenv

rbenv init   # follow the shell hook instructions it prints, then restart your shell
rbenv install 3.3.6
rbenv global 3.3.6
ruby -v      # confirm 3.3.x
```

**Install Rails 8**:
```bash
gem install rails -v '~> 8.0'
rbenv rehash
rails -v     # confirm 8.x.x
```

**Install SQLite dev libraries** (needed to build the `sqlite3` gem's
native extension):
```bash
# Arch / Garuda
sudo pacman -S sqlite

# Debian / Ubuntu
sudo apt install libsqlite3-dev

# macOS
brew install sqlite3
```

## Setup

```bash
git clone <this-repo-url>
cd inventory_erp
bundle install
bin/rails db:setup      # creates the DB, loads the schema, runs db/seeds.rb if present
bin/rails server
```

Visit `http://localhost:3000`. Create your first company and admin user
either through the sign-up flow (once built) or via `bin/rails console`:

```ruby
company = Company.create!(name: "Acme Hostels")
User.create!(email_address: "admin@acme.com", password: "password123",
             company: company, role: :admin)
```

## Status

Core data model and business logic (companies, users/roles, products,
warehouses, suppliers, stock ledger, purchase/sales order workflows) are in
place. Controllers, views, and a low-stock dashboard are in progress.
