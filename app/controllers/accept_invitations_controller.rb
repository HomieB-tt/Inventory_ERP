class AcceptInvitationsController < ApplicationController
  allow_unauthenticated_access only: [:show, :create]
  before_action :set_invitation

  def show
    unless @invitation&.pending?
      redirect_to new_session_path, alert: "This invite is no longer valid."
    end
  end

  def create
    unless @invitation&.pending?
      redirect_to new_session_path, alert: "This invite is no longer valid."
      return
    end

    user = @invitation.accept!(
      password: params[:password],
      password_confirmation: params[:password_confirmation]
    )
    start_new_session_for(user)
    redirect_to root_path, notice: "Welcome to #{@invitation.company.name}!"
  rescue ActiveRecord::RecordInvalid => e
    flash.now[:alert] = e.message
    render :show, status: :unprocessable_entity
  end

  private

  def set_invitation
    @invitation = Invitation.find_by(token: params[:token])
    redirect_to new_session_path, alert: "Invite not found." if @invitation.nil?
  end
end
