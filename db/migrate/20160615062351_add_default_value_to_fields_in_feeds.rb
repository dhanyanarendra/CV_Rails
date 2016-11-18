class AddDefaultValueToFieldsInFeeds < ActiveRecord::Migration
  def up
    change_column :feeds, :pledge, :boolean, :default => false
    change_column :feeds, :priority, :boolean, :default => false
  end

  def down
    change_column :feeds, :pledge, :boolean, :default => nil
    change_column :feeds, :priority, :boolean, :default => nil
  end
end
