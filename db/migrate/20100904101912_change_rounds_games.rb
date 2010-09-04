class ChangeRoundsGames < ActiveRecord::Migration
  def self.up
    add_column :rounds, :schedule_id, :integer
    add_column :games, :round_id, :integer
  end

  def self.down
    drop_column :rounds, :schedule_id
    drop_column :games, :round_id
  end
end
