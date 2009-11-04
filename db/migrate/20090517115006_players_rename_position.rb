class PlayersRenamePosition < ActiveRecord::Migration
  def self.up
		rename_column :players, :position, :position_id
  end

  def self.down
		rename_column :players, :position_id, :position
  end
end
