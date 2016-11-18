class AddLikeCountAndPledgeCountToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :like_count, :integer, :default => 0
    add_column :feeds, :pledge_count, :integer, :default => 0
  end
end
