module OrdersHelper
  def total_price quantity, unit_price
    unit_price * quantity
  end
end
