class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :title
      t.string :email
      t.string :phone
      t.string :address
      t.string :password_digest

      t.timestamps null: false
    end
  end
end
