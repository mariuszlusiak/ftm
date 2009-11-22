class UsersUseDefaultPointingSystem < ActiveRecord::Migration
  def self.up
    add_column :users, :use_default_pointing_system, :boolean, :null => false,
      :default => true
  end

  def self.down
    remove_column :users, :use_default_pointing_system
  end
end
