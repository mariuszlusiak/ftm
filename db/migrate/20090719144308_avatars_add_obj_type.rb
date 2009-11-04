class AvatarsAddObjType < ActiveRecord::Migration
  def self.up
		add_column :avatars, :obj_type, :string 
  end

  def self.down
		remove_column :avatars, :obj_type
  end
end
