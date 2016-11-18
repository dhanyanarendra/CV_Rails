class AddColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :age, :integer
    add_column :users, :sex, :string
    add_column :users, :race, :string
    add_column :users, :profession, :string
    add_column :users, :material_status, :string
    add_column :users, :street, :string
  end
end
