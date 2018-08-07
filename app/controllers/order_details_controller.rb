class OrderDetailsController < ApplicationController
  before_action :load_product, only: :create
  before_action :load_cart, only: :create

  def create
    if @cart
      if @cart.key?(@product.id.to_s)
        @cart[@product.id] = @cart[@product.id.to_s] + 1
      else
        @cart[@product.id] = 1
      end
      flash[:success] = t("controller.carts.add_to_cart_sucess")
    end
  end

  def update; end

  def destroy; end

  private 

  def load_product
    @product = Product.find_by id: params[:product_id]
    if @product.nil?
      flash[:danger] = t("controller.carts.product_not_found")
    end
  end

  def load_cart
    @cart = current_cart
    if @cart.nil?
      flash[:danger] = t("controller.carts.cart_not_found")
    end
  end
end
