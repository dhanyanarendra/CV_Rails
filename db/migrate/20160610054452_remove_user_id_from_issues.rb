class RemoveUserIdFromIssues < ActiveRecord::Migration
  def change
    remove_column :issues, :user_id, :integer
  end
end
