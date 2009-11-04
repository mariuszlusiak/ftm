class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :name
      t.string :first_name
      t.string :email
      t.string :mobile
      t.text :description
      t.date :date_of_birth
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :people
  end
end
