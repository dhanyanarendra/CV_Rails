class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :short_description
      t.string :user_role
      t.boolean :user_creator, :default => false
      t.timestamps null: false
    end
  end
end
