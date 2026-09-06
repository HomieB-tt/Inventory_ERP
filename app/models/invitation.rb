class Invitation < ApplicationRecord
  belongs_to :company
  belongs_to :invited_by, class_name: "User"
  has_secure_token :token

  enum :role, { viewer: 0, staff: 1, admin: 2 }

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  before_validation :set_expiration, on: :create

  scope :pending, -> { where(accepted_at: nil) }

  def expired?
    expires_at.present? && expires_at.past?
  end

  def pending?
    accepted_at.nil? && !expired?
  end

  # Creates the invited User and marks this invitation accepted, both
  # inside a transaction so a failed User creation doesn't leave the
  # invitation in a half-consumed state.
  def accept!(password:, password_confirmation:)
    transaction do
      user = User.create!(
        company: company, email_address: email, role: role,
        password: password, password_confirmation: password_confirmation
      )
      update!(accepted_at: Time.current)
      user
    end
  end

  private

  def set_expiration
    self.expires_at ||= 7.days.from_now
  end
end
