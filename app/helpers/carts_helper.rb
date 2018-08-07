module CartsHelper
  def total
    @cart = session[:cart]
    @sum = 0
    @cart.each do |key, val|
      @sum += val * Product.by_id(key)[0].price
    end
    @sum
  end
  
  def get_giftcode
    @giftcode_user = Giftcode.get_giftcode(@current_user.id)
    if @giftcode_user.empty?
      @giftcode = 1
    else
      @giftcode = @giftcode_user[0].id
    end
  end
end
