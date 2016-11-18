class AddDefaultToFeeds < ActiveRecord::Migration
  def change
    change_column :feeds, :like, :boolean, :default => false
  end
end
