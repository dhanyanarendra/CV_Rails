class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :candidate_name
      t.string :year
      t.string :state
      t.string :district
      t.string :election
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
