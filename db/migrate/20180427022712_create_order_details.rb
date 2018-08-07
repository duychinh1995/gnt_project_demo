class CreateOrderDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :order_details do |t|
      t.integer :quantity
      t.integer :unitprice
      t.integer :discount
      t.integer :amount
      t.timestamps
    end
   end
end
