class RemoveEndTimeAndAddBackInFeeds < ActiveRecord::Migration
  def change
    remove_column :feeds, :end_time, :string
    add_column :feeds, :end_time, :time
  end
end
