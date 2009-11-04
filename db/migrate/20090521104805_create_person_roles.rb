class CreatePersonRoles < ActiveRecord::Migration
  def self.up
    create_table :person_roles do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :person_roles
  end
end
