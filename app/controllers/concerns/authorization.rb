module Authorization
  extend ActiveSupport::Concern

  class NotAuthorizedError < StandardError; end

  ROLE_RANK = { "viewer" => 0, "staff" => 1, "admin" => 2 }.freeze

  included do
    rescue_from NotAuthorizedError, with: :deny_access
  end

  private

  # Usage in a controller: before_action -> { require_role!(:staff) }, only: [:new, :create]
  def require_role!(minimum)
    user_rank = ROLE_RANK.fetch(Current.user&.role, -1)
    minimum_rank = ROLE_RANK.fetch(minimum.to_s, 99)
    raise NotAuthorizedError unless user_rank >= minimum_rank
  end

  def deny_access
    redirect_to root_path, alert: "You don't have permission to do that."
  end
end
