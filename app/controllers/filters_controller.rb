class FiltersController < ApplicationController
  def show
    @categories = Category.all.map{|c| [c.title, c.id]}
    @products = Product.filter_by_alphabet(params[:alphabet])
                       .filter_by_name(params[:name])
                       .filter_by_category(params[:category_id])
                       .filter_by_min_price(params[:min_price])
                       .filter_by_max_price(params[:max_price])
                       .paginate page: params[:page], per_page: Settings.per_page
  end
end
