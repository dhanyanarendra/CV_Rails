class AddDefaultValueToQuantityInFeeds < ActiveRecord::Migration
  def up
    change_column :feeds, :quantity, :integer, :default => 0
  end

  def down
    change_column :feeds, :quantity, :integer, :default => nil
  end
end
