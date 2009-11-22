class CreateGoals < ActiveRecord::Migration
  def self.up
    create_table :goals do |t|
      t.integer :game_result_id
      t.integer :team_id
      t.integer :player_id
      t.integer :minute
      t.boolean :own_goal

      t.timestamps
    end
  end

  def self.down
    drop_table :goals
  end
end
