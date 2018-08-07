class CartsController < ApplicationController
  before_action :load_cart, only: %i(show plus minus)

  def show
    if @cart
      @products = []
      @product_ids = @cart.collect{|key,value| key }
      @products = Product.by_product_id(@product_ids)
    else
      flash[:danger] = t("controller.carts.cart_not_found")
    end
  end

  def plus
    if @cart && @cart[params[:key]]
      @cart[params[:key]] = @cart[params[:key]] + 1
      redirect_to your_cart_path
    else
      flash[:danger] = t("controller.carts.product_not_found")
    end
  end

  def minus
    if @cart && @cart[params[:key]]
      if @cart[params[:key]] > 1
        @cart[params[:key]] = @cart[params[:key]] - 1
      else
        @cart.delete(params[:key])
      end
      redirect_to your_cart_path
    else
      flash[:danger] = t("controller.carts.product_not_found")
    end
  end

  def destroy
    if session[:cart] 
      session[:cart] = nil
      redirect_to root_path
    else
      redirect_to root_path
    end
  end

  private 

  def load_cart
    @cart = current_cart
    if @cart.nil?
      flash[:danger] = t("controller.carts.cart_not_found")
    end
  end
end
