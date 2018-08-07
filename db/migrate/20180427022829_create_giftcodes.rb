class CreateGiftcodes < ActiveRecord::Migration[5.1]
  def change
    create_table :giftcodes do |t|
      t.string :code
      t.integer :discount
      t.timestamps
    end
  end
end
