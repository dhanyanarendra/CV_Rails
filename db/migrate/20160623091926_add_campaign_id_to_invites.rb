class AddCampaignIdToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :campaign_id, :integer
  end
end
