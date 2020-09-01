class PasswordResetsController < ApplicationController
  before_action :get_user, :check_expiration, :valid_user, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "email_reset_sent"
      redirect_to root_url
    else
      flash.now[:danger] = t "email_not_found"
      render :new
    end
  end

  def edit; end

  def update
    if user_params[:password].blank?
      @user.errors.add(:password, "can't be empty")
      render :edit
    elsif @user.update_attributes user_params
      log_in @user
      flash[:success] = t "password_reset_success"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def get_user
    @user = User.find_by email: params[:email]
  end

  def valid_user
    return if (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
    redirect_to root_url
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  # Checks expiration of reset token.
  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = t "password_reset_expired"
      redirect_to new_password_reset_url
    end
  end
end
