class CreateTournamentFields < ActiveRecord::Migration
  def self.up
    create_table :tournament_fields do |t|
      t.integer :tournament_id
      t.integer :field_id

      t.timestamps
    end
  end

  def self.down
    drop_table :tournament_fields
  end
end
