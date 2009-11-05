class CreateGameResults < ActiveRecord::Migration
  def self.up
    create_table :game_results do |t|
      t.integer :game_id
      t.integer :home_team_score
      t.integer :away_team_score
      t.integer :home_team_points
      t.integer :away_team_points

      t.timestamps
    end
  end

  def self.down
    drop_table :game_results
  end
end
