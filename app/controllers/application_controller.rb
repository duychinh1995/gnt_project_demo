class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include CartsHelper

  def current_cart
    session[:cart] ||= {}
  end
end
