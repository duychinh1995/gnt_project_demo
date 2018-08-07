class Admin::UsersController < Admin::AdminController
  before_action :find_user, :admin_user, only: :destroy

  def index
    @users = User.search_by_name(params[:search])
                 .paginate page: params[:page], per_page: Settings.per_page
  end

  def destroy
    if !@user.admin? && @user.destroy
      flash[:success] = t "controller.users.del_user"
    else
      flash[:danger] = t "controller.users.del_user_fail"
    end
    redirect_to admin_users_path
  end

  private

  def find_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "controller.users.ple_log"
    redirect_to admin_users_path
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
