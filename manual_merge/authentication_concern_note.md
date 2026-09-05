# MANUAL MERGE — app/controllers/concerns/authentication.rb

This file already exists from `bin/rails generate authentication`. Find the
line where it sets `Current.session = session` (inside the private
`resume_session` / after successful authentication), and add the line below
immediately after it:

```ruby
Current.company = Current.user&.company
```

That's the only change needed here. Everything else the generator wrote
(the `require_authentication`/`resume_session` methods, the cookie-based
session lookup) stays as-is.
