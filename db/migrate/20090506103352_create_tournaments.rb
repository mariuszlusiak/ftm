class CreateTournaments < ActiveRecord::Migration
  def self.up
    create_table :tournaments do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.text :description
      t.string :organizer
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :tournaments
  end
end
