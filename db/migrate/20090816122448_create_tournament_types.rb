class CreateTournamentTypes < ActiveRecord::Migration
  def self.up
    create_table :tournament_types do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :tournament_types
  end
end
