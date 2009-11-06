class GamesAddTournamentId < ActiveRecord::Migration
  def self.up
    add_column :games, :tournament_id, :integer
  end

  def self.down
    remove_column :games, :tournament_id
  end
end
