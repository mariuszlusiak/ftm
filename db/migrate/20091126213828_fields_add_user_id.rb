class FieldsAddUserId < ActiveRecord::Migration
  def self.up
    add_column :fields, :user_id, :integer
  end

  def self.down
    remove_column :fields, :user_id
  end
end
