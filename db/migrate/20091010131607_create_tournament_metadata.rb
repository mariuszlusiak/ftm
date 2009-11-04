class CreateTournamentMetadata < ActiveRecord::Migration
  def self.up
    create_table :tournament_metadata do |t|
      t.integer :tournament_id
      t.integer :teams_count
      t.integer :games_count
      t.integer :default_game_duration

      t.timestamps
    end
  end

  def self.down
    drop_table :tournament_metadata
  end
end
