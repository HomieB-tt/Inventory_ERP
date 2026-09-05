# MANUAL MERGE — do not just copy over app/models/user.rb.
# The Rails 8 `generate authentication` command already created that file
# with `has_secure_password` and `has_many :sessions`. Add these lines
# to it instead of replacing the whole file:

class User < ApplicationRecord
  belongs_to :company
  # has_secure_password        <- already present, leave it
  # has_many :sessions, dependent: :destroy   <- already present, leave it

  enum :role, { viewer: 0, staff: 1, admin: 2 }

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, presence: true, uniqueness: { scope: :company_id }
end
