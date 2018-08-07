class OrdersController < ApplicationController
  before_action :load_order, only: :show
  before_action :load_cart, only: %i(new create)

  def index; end

  def show; end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new order_params
    ActiveRecord::Base.transaction do
      @order.save
      @cart.each do |key, val|
        @order_detail = OrderDetail.new(product_id: key.to_i, order_id: @order.id, quantity: val)
        @order_detail.save
      end
      session[:cart] = nil
      flash[:success] = t "controller.orders.create_order_success"
      redirect_to root_path
      raise ActiveRecord::Rollback
      flash[:danger] = t "controller.orders.create_order_errror"
      redirect_to root_path
    end
  end

  private

  def load_order
    @order = Order.find_by id: params[:id]
    return if @order
    flash[:danger] = t "controller.orders.order_not_exist"
    redirect_to orders_path
  end

  def load_cart
    @cart = current_cart
    flash[:danger] = t "controller.carts.cart_not_found" if @cart.nil?
  end
  
  def order_params
    params.require(:order).permit :status, :totalamount, :user_id, :giftcode_id
  end
end
