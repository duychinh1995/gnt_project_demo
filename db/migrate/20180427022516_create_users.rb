class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :password_digest
      t.string :email
      t.integer :role, default: 1
      t.integer :phone
      t.string :address
      t.string :gender
      t.string :avartar
      t.string :activation_digest, :string
      t.boolean :activated, default: false
      t.datetime :activated_at
      t.timestamps
    end
  end
end
