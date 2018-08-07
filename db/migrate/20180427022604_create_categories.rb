class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories do |t|
      t.string :title
      t.integer :parent_id
      t.string :catcontent
      t.integer :status
      t.timestamps
    end
  end
end
