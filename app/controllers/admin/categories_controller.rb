class Admin::CategoriesController < Admin::AdminController
  before_action :require_admin
  before_action :load_category, except: %i(new create index)
  before_action :map_category, only: %i(create update)
  before_action :load_products_in_category, only: %i(show destroy)
  before_action :load_all_category, only: %i(new edit create)

  def index
    @categories = Category.all.ordered_by_title
                          .search_by_title(params[:search])
                          .paginate page: params[:page], per_page: Settings.per_page
  end

  def new
    @category = Category.new
  end

  def show; end

  def create
    @category = Category.new category_params
    if @category.save
      flash[:success] = t "controller.category.success"
      redirect_to admin_categories_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @category.update category_params
      flash[:success] = t "controller.category.success"
      redirect_to admin_categories_path
    else
      render :edit
    end
  end

  def destroy
    @check_list_product = @category.products
    if params[:confirm_delete].present?
      delete_category
    elsif params[:confirm_delete_update].present?
      delete_update_category
    elsif @check_list_product.present?
      message_exist
    else
      delete_category
    end
  end

  private

  def map_category
    @categories = Category.all.map{|c| [c.title, c.id]}
  end

  def category_params
    params.require(:category).permit(:title, :parent_id,
      :status, :catcontent)
  end

  def delete_category
    if @category.destroy
      flash[:success] = t "controller.category.del_cate"
    else
      flash[:danger] = t "controller.category.del_cate_fail"
    end
    redirect_to admin_categories_path
  end

  def delete_update_category
    Product.transaction do
      @category.products.update(category_id: params[:category][:id])
      @category.reload
      if @category.destroy
        flash[:success] = t "controller.category.del_up_cate"
      else
        raise ActiveRecord::Rollback
        flash[:danger] = t "controller.category.del_up_cate_fail"
      end
    end
    redirect_to admin_categories_path
  end

  def load_category
    @category = Category.find_by id: params[:id]
    return if @category
    flash[:danger] = t "controller.category.cate_not_exist"
    redirect_to admin_categories_path
  end

  def message_exist
    flash[:danger] = t "controller.category.exist_product"
    render :show
  end

  def load_all_category
    @categories = Category.all
  end

  def load_products_in_category
    @categories = Category.by_ids(@category.id)
    @products = @category.products.paginate(page: params[:page],
      per_page: Settings.per_page_order_items)
  end
end
