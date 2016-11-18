class AddCordinatorCampaignIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cordinator_campaign_id, :integer
  end
end
