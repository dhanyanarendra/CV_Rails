class RenameColumnsInFeeds < ActiveRecord::Migration
  def change
    rename_column :feeds, :time, :start_time
    rename_column :feeds, :duration, :end_time
  end
end
