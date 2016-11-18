class CreatePledges < ActiveRecord::Migration
  def change
    create_table :pledges do |t|
      t.boolean :priority_done
      t.boolean :pledge_done
      t.integer :user_contributor_id
      t.integer :feed_id
      t.boolean :pledged

      t.timestamps null: false
    end
  end
end
