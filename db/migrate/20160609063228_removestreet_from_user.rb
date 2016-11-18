class RemovestreetFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :street
  end
end
