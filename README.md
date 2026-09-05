# Inventory/ERP — Patch 1: Core domain models

## Before extracting this
Make sure you've already run, in a fresh directory:
```
rails new inventory_erp
cd inventory_erp
bin/rails generate authentication
bin/rails db:migrate
```
This patch assumes `users` and `sessions` tables already exist (from the
authentication generator) before you layer this on top.

## How to apply
1. Extract this zip's contents directly into your `inventory_erp/` root —
   the `db/` and `app/` folders here match Rails' real paths, so files land
   exactly where they belong.
2. Do **not** copy anything from `manual_merge/` directly into `app/models/`
   or `app/controllers/concerns/` — those two files (`user.rb`, `current.rb`,
   `authentication.rb`) already exist from the generator and need small
   hand edits, not overwrites. Each file in `manual_merge/` explains exactly
   what to add.
3. Run `bin/rails db:migrate`.
4. Sanity check in `bin/rails console`:
   ```ruby
   c = Company.create!(name: "Acme Hostels")
   u = User.create!(email_address: "a@a.com", password: "password123", company: c, role: :admin)
   w = Warehouse.create!(company: c, name: "Main")
   p = Product.create!(company: c, sku: "SKU1", name: "Bunk sheets", unit_price: 5, reorder_threshold: 10)
   StockMovement.create!(company: c, product: p, warehouse: w, user: u, quantity: 50, movement_type: :manual_adjustment)
   p.stock_on_hand # => 50
   ```

## What's in this patch
- `db/migrate/` — 10 migrations: companies, user tenancy/role columns,
  warehouses, suppliers, products, stock_movements (the audit ledger),
  purchase_orders + lines, sales_orders + lines.
- `app/models/` — Company, Product, Warehouse, Supplier, StockMovement,
  PurchaseOrder(+Line), SalesOrder(+Line). Business logic included:
  `PurchaseOrder#receive!` and `SalesOrder#fulfill!` both create
  `StockMovement` rows rather than mutating a stored quantity — stock levels
  are always *derived* from the movement ledger via `Product#stock_on_hand`.
- `manual_merge/` — instructions (not auto-applied files) for the two spots
  that touch generator-created files: adding `company`/`role` to `User`,
  and adding `Current.company` alongside `Current.session`.

## Tenant isolation approach
No `default_scope` gem magic — scoping is explicit and always goes through
`Current.company`, e.g. `Current.company.products.find(params[:id])` in a
controller. Verbose, but it means tenant isolation is never silently
bypassed in a console session or background job where `Current` isn't set.

## Git
If `rails new` didn't skip git (it doesn't, by default), your project is
already a git repo. After applying this patch:
```
git add .
git commit -m "Add core inventory/ERP domain models and migrations"
```
Then create the GitHub repo and push:
```
gh repo create inventory-erp --public --source=. --push
```
(or push manually if you don't have `gh` installed: create the repo on
github.com, then `git remote add origin <url> && git push -u origin main`)

## Next
Controllers + views (index/show/new/edit for each resource, plus a
low-stock dashboard) come in the next patch.
