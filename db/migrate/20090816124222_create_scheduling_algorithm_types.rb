class CreateSchedulingAlgorithmTypes < ActiveRecord::Migration
  def self.up
    create_table :scheduling_algorithm_types do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :scheduling_algorithm_types
  end
end
