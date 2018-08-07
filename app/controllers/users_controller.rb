class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(create new)
  before_action :load_user, only: :show
  before_action :correct_user, except: :show

  def show
    @products = Product.by_history_order(current_user.id)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = t "controller.users.ple_check_mail"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit
    @user = User.find_by id: params[:id]
  end

  def update
    @user = User.find_by id: params[:id]
    if @user.update user_params
      flash[:success] = t "controller.users.up_profile"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "controller.users.users_not_exist"
    redirect_to users_path
  end

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation,
      :address, :phone, :gender, :avartar
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "controller.users.ple_log"
    redirect_to login_url
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to root_url unless current_user?(@user)
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
