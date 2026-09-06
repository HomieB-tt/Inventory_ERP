class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
class User < ApplicationRecord
  belongs_to :company
  has_secure_password
  has_many :sessions, dependent: :destroy
  enum :role, { viewer: 0, staff: 1, admin: 2 }
  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, presence: true, uniqueness: { scope: :company_id }

  def at_least?(min_role)
    self.class.roles[role] >= self.class.roles[min_role.to_s]
  end
end
