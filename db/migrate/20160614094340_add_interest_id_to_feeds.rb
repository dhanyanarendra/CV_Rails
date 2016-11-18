class AddInterestIdToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :interest_id, :integer
  end
end
