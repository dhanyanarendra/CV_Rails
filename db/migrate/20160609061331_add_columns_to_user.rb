class AddColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :zip, :integer
    add_column :users, :city, :string
    add_column :users, :state, :string
  end
end
