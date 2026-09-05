class RegistrationsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]

  def new
    @company = Company.new
    @user = User.new
  end

  def create
    @company = Company.new(company_params)
    @user = User.new(user_params.merge(role: :admin))

    ActiveRecord::Base.transaction do
      @company.save!
      @user.company = @company
      @user.save!
    end

    start_new_session_for(@user)
    redirect_to root_path, notice: "Welcome! Your company is set up."
  rescue ActiveRecord::RecordInvalid
    render :new, status: :unprocessable_entity
  end

  private

  def company_params
    params.require(:company).permit(:name)
  end

  def user_params
    params.require(:user).permit(:email_address, :password, :password_confirmation)
  end
end
