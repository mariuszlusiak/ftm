class GameResultsAddFinished < ActiveRecord::Migration
  def self.up
    add_column :game_results, :finished, :boolean, :default => false
  end

  def self.down
    remove_column :game_results, :finished
  end
end
