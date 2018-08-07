class Admin::AdminController < ApplicationController
  layout "admin/application"
  before_action :require_admin

  def require_admin
    return if current_user && current_user.admin?
    flash[:danger] = t "controller.orders.role"
    redirect_to login_url
  end

  def index; end
end
