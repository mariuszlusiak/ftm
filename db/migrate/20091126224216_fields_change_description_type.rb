class FieldsChangeDescriptionType < ActiveRecord::Migration
  def self.up
    change_column :fields, :description, :text
  end

  def self.down
    change_column :fields, :description, :string
  end
end
