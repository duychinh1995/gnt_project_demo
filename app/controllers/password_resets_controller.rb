class PasswordResetsController < ApplicationController
  before_action :getuser, only: %i(edit update)
  before_action :valid_user, only: %i(edit update)
  before_action :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "controller.password.reset_mail"
      redirect_to root_url
    else
      flash.now[:danger] = t "controller.password.found_mail"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, t("controller.password.cant_empty"))
      render :edit
    elsif @user.update(user_params)
      log_in @user
      flash[:success] = t "controller.password.pass_reset"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def getuser
    @user = User.find_by email: params[:email]
  end

  def valid_user
    redirect_to root_url unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t "controller.password.pass_expired"
    redirect_to new_password_reset_url
  end
end
