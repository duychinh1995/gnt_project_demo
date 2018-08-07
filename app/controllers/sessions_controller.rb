class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      check_active user
    else
      flash.now[:danger] = t "controller.application.invalid_em_pas"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def check_remember user
    log_in user
    params[:session][:remember_me] == Settings.check_remember ? remember(user) : forget(user)
    redirect_back_or user
  end

  def check_active user
    if user.activated?
      check_remember user
    else
      message = t "controller.session.account_not"
      message += t "controller.session.check_mail"
      flash[:warning] = message
      redirect_to root_url
    end
  end
end
