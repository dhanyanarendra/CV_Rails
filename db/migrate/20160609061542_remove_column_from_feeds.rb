class RemoveColumnFromFeeds < ActiveRecord::Migration
  def change
    remove_column :feeds, :like
    remove_column :feeds, :like_count
  end
end
