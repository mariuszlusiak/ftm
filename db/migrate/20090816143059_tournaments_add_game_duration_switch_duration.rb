class TournamentsAddGameDurationSwitchDuration < ActiveRecord::Migration
  def self.up
    add_column :tournaments, :game_duration, :integer
    add_column :tournaments, :switch_duration, :integer
  end

  def self.down
    remove_column :tournaments, :game_duration
    remove_column :tournaments, :switch_duration
  end
end
