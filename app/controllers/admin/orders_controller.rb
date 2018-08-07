class Admin::OrdersController < Admin::AdminController
  before_action :require_admin
  before_action :load_order, only: %i(edit update show)

  def index
    @orders = Order.includes(:user).paginate page: params[:page],
      per_page: Settings.per_page_order_items
  end

  def show; end

  def edit
    @order_details = OrderDetail.eager_load(:product).by_order(@order.id)
  end

  def update
    if @order.update order_params
      flash[:success] = t "controller.orders.success"
      redirect_to admin_orders_path
    else
      render :edit
    end
  end

  private

  def order_params
    params.require(:order).permit :status
  end

  def load_order
    @order = Order.find_by id: params[:id]
    return if @order
    flash[:danger] = t "controller.orders.order_not_exist"
    redirect_to orders_path
  end
end
