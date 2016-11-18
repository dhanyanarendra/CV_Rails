class AddRoleNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role_name, :string, :default => "user"
  end
end
