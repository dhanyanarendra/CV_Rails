class ChangeTimeDataTypeInFeeds < ActiveRecord::Migration
  def up
    remove_column :feeds, :start_time, :time
    remove_column :feeds, :end_time, :time
    add_column :feeds, :start_time, :timestamp
    add_column :feeds, :end_time, :timestamp
  end

  def down
    remove_column :feeds, :start_time, :timestamp
    remove_column :feeds, :end_time, :timestamp
    add_column :feeds, :start_time, :time
    add_column :feeds, :end_time, :time
  end
end
