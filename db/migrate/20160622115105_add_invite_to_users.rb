class AddInviteToUsers < ActiveRecord::Migration
  def change
    add_column :users, :invite_id, :integer
  end
end
