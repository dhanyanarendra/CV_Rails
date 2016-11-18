class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :title
      t.integer :quantity
      t.date :date
      t.time :time
      t.string :duration
      t.string :location
      t.text :short_description
      t.integer :campaign_id
      t.integer :like_count
      t.boolean :pledge
      t.boolean :like
      t.boolean :priority
      t.boolean :done
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
