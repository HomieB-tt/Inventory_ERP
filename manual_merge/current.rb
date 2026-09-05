# MANUAL MERGE — app/models/current.rb already exists (from `generate authentication`).
# Add the `attribute :company` line and the delegate stays the same shape,
# just add company alongside what's already there:

class Current < ActiveSupport::CurrentAttributes
  attribute :session
  attribute :company

  delegate :user, to: :session, allow_nil: true
end
