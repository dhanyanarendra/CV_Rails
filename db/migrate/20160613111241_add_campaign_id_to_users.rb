class AddCampaignIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :campaign_id, :integer
  end
end
