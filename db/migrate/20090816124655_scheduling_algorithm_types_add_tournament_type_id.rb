class SchedulingAlgorithmTypesAddTournamentTypeId < ActiveRecord::Migration
  def self.up
    add_column :scheduling_algorithm_types, :tournament_type_id, :integer
  end

  def self.down
    drop_column :scheduling_algorithm_types, :tournaments_types_id
  end
end
