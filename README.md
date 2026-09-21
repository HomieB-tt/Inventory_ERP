# Inventory & Warehouse ERP

A multi-tenant inventory management and order-processing system built with
Ruby on Rails. Multiple companies (tenants) can each manage their own
products, warehouses, suppliers, and stock. Every stock change is
recorded as an immutable ledger entry rather than a mutable "quantity"
field, so stock levels are always derived and auditable.

## Features

- **Multi-tenant**: each `Company` is fully isolated; users belong to
  exactly one company and only ever see that company's data.
- **Self-serve sign-up**: anyone can create a new company and its first
  admin user from the sign-up page, no console access needed.
- **Team management**: admins can see the full member roster (email,
  role, join date) and the complete invitation history (pending,
  accepted, or expired), not just an in-flight queue. Invites are
  link-based (no email delivery): each generates a unique, expiring link
  (7 days) the admin shares manually, and pending ones can be revoked.
- **Role-based access**: `viewer` (read-only), `staff` (day-to-day
  operations: create/edit records, receive purchase orders, fulfill sales
  orders, transfer stock, record manual adjustments, import products),
  and `admin` (everything staff can do, plus deleting records and
  managing the team). Enforced both in controllers (a request for an
  action above your role redirects with an error) and in views (buttons
  you can't use aren't shown).
- **Product catalog**: SKUs, categories, unit pricing, and per-product
  reorder thresholds, with low-stock highlighting throughout the UI.
- **CSV import/export for products**: export the full catalog (including
  a computed total-stock-on-hand column for reference) or bulk
  create/update products by uploading a CSV matched on SKU. Stock itself
  is never touched by import, since every stock change has to go through
  the ledger.
- **Warehouses & suppliers**: track stock across multiple physical
  locations and the suppliers you buy from.
- **Multi-warehouse transfers**: move stock between warehouses for the
  same company, with validation that there's enough stock at the source.
- **Manual stock adjustments**: add initial stock, correct counts after a
  physical audit, or record damage/shrinkage directly, without needing a
  purchase order. Requires a reason, which shows up in the ledger.
- **Stock ledger**: every stock change (purchase receipt, sale, manual
  adjustment, transfer) is recorded as a `StockMovement`. Current stock
  on hand is computed by summing the ledger, never stored redundantly.
  The ledger is browsable and filterable by product or warehouse.
- **Purchase orders**: draft, order, receive workflow with dynamically
  addable/removable line items (no page reload, powered by Stimulus).
  Receiving stock generates the corresponding ledger entries automatically.
- **Sales orders**: draft, confirm, fulfill workflow, same dynamic line
  item editing. Fulfilling an order deducts stock via the same ledger
  mechanism.
- **Dashboard**: at-a-glance counts, a low-stock list, and a feed of
  recent stock movements.

## Tech stack

- Ruby 3.3+ / Rails 8
- SQLite (Rails 8 defaults, used for the primary DB as well as Solid
  Queue/Cache/Cable)
- Active Storage with libvips for image variants
- Turbo & Stimulus (Hotwire) for interactivity, no separate JS build step
  (import maps)
- Session-based authentication via Rails 8's built-in `has_secure_password`
  authentication generator, extended with token-based team invites
  (`has_secure_token`)
- Hand-rolled role-hierarchy authorization (no external gem: the
  permission model is a simple viewer/staff/admin rank check, not
  per-resource ownership rules, so a full policy-object gem like Pundit
  would be more machinery than the problem needs)
- Plain CSS design system (no framework): light neutral surfaces with a
  steel-blue accent, monospace reserved for tabular data (SKUs,
  quantities, currency)

## Prerequisites

You'll need Ruby 3.3+, Rails 8, SQLite, and libvips installed. The
recommended way to install Ruby is via a version manager (`rbenv`) rather
than your OS's system package:

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

**Install libvips** (needed for Active Storage image variants):
```bash
# Arch / Garuda
sudo pacman -S libvips

# Debian / Ubuntu
sudo apt install libvips

# macOS
brew install vips
```

**Note on Ruby 3.4+**: `csv` was unbundled from Ruby's default standard
library starting in 3.4, so it needs to be an explicit Gemfile
dependency (already included: `gem "csv"`).

## Setup

```bash
git clone <this-repo-url>
cd inventory_erp
bundle install
bin/rails db:setup      # creates the DB, loads the schema, runs db/seeds.rb if present
bin/rails server
```

Visit `http://localhost:3000` and click "Create a company account" to sign
up, or sign in if you already have an account. To seed initial stock for a
new product, use "New adjustment" from the Stock ledger page rather than
the console.

## Status

Core data model, business logic, controllers/views for all core resources,
the dashboard, self-serve sign-up, team management, dynamic order line
items, role-based access control, multi-warehouse transfers, manual stock
adjustments, and CSV import/export are in place and usable end-to-end.

**Roadmap:**
- Automated tests asserting cross-tenant data access fails, and that each
  role's permissions are actually enforced
