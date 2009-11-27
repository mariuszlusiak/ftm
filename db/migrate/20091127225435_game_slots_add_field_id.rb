class GameSlotsAddFieldId < ActiveRecord::Migration
  def self.up
    add_column :game_slots, :field_id, :integer
  end

  def self.down
    remove_column :game_slots, :field_id
  end
end
