class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.integer :totalamount
      t.integer :status
      t.timestamps
    end
  end
end
