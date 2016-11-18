class RenameUserIdColumnInCampaigns < ActiveRecord::Migration
  def change
    rename_column :campaigns, :user_id, :creator_id
  end
end
