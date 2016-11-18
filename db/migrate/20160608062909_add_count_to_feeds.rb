class AddCountToFeeds < ActiveRecord::Migration
  def change
    change_column :feeds, :like_count, :integer, :default => 0
  end
end
