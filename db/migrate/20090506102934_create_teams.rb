class CreateTeams < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.string :name
      t.integer :trainer_id
      t.integer :manager_id
      t.integer :captain_id
      t.text :description
      t.string :city
      t.integer :year_founded
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :teams
  end
end
