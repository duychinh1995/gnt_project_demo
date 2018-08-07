class AddOrderRefToGiftcode < ActiveRecord::Migration[5.1]
  def change
    add_reference :giftcodes, :user, foreign_key: true
  end
end
