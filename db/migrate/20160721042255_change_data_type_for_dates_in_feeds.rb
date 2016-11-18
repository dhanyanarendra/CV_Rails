class ChangeDataTypeForDatesInFeeds < ActiveRecord::Migration
  def up
    change_column :feeds, :start_time, :string
    change_column :feeds, :end_time, :string
  end

  def down
    change_column :feeds, :start_time, :datetime
    change_column :feeds, :end_time, :datetime
  end
end
