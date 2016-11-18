class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :file_name, :string
    add_column :users, :file, :string
  end
end
