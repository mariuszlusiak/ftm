class CreateTournamentGameSlots < ActiveRecord::Migration
  def self.up
    create_table :tournament_game_slots do |t|
      t.integer :tournament_id
      t.datetime :start
      t.datetime :end
      t.string :place

      t.timestamps
    end
  end

  def self.down
    drop_table :tournament_game_slots
  end
end
