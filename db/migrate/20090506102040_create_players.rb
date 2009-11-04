class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.string :name
      t.string :first_name
      t.integer :current_number
      t.integer :position
      t.text :description
      t.date :date_of_birth

      t.timestamps
    end
  end

  def self.down
    drop_table :players
  end
end
