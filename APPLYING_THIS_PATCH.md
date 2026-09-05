# Applying this patch

## Before extracting
Make sure you've already run, in a fresh directory:
```
rails new inventory_erp
cd inventory_erp
bin/rails generate authentication
bin/rails db:migrate
```
This patch assumes `users` and `sessions` tables already exist (from the
authentication generator) before you layer this on top.

## Apply
1. Extract this zip's contents directly into your `inventory_erp/` root —
   the `db/` and `app/` folders here match Rails' real paths.
2. Do **not** copy anything from `manual_merge/` directly into
   `app/models/` or `app/controllers/concerns/` — `user.rb`, `current.rb`,
   and the authentication concern already exist from the generator and
   need small hand edits, not overwrites. Each file in `manual_merge/`
   explains exactly what to add.
3. Run `bin/rails db:migrate`.
4. Copy `README.md` from this zip over your project's placeholder
   `README.md` (or merge it in) — it's written as the project's real
   README, not a patch note.

## Sanity check
```ruby
c = Company.create!(name: "Acme Hostels")
u = User.create!(email_address: "a@a.com", password: "password123", company: c, role: :admin)
w = Warehouse.create!(company: c, name: "Main")
p = Product.create!(company: c, sku: "SKU1", name: "Bunk sheets", unit_price: 5, reorder_threshold: 10)
StockMovement.create!(company: c, product: p, warehouse: w, user: u, quantity: 50, movement_type: :manual_adjustment)
p.stock_on_hand # => 50
```

## Git / GitHub
```bash
git add .
git commit -m "Add core inventory/ERP domain models and migrations"
gh repo create inventory-erp --public --source=. --push
```
(or without `gh`: create the repo on github.com, then
`git remote add origin <url> && git push -u origin main`)

## Next
Controllers + views (index/show/new/edit for each resource, plus a
low-stock dashboard) come in the next patch.
