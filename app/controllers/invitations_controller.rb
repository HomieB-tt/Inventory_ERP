class InvitationsController < ApplicationController
  before_action -> { require_role!(:admin) }
  before_action :set_invitation, only: [:destroy]

  def index
    @team_members = Current.company.users.order(:email_address)
    @invitations = Current.company.invitations.order(created_at: :desc)
  end

  def new
    @invitation = Current.company.invitations.new
  end

  def create
    @invitation = Current.company.invitations.new(invitation_params)
    @invitation.invited_by = Current.user
    if @invitation.save
      redirect_to invitations_path, notice: "Invite created for #{@invitation.email}. Copy the link below and send it to them."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    if @invitation.pending?
      @invitation.destroy
      redirect_to invitations_path, notice: "Invitation revoked."
    else
      redirect_to invitations_path, alert: "Only pending invitations can be revoked."
    end
  end

  private

  def set_invitation
    @invitation = Current.company.invitations.find(params[:id])
  end

  def invitation_params
    params.require(:invitation).permit(:email, :role)
  end
end
