class PeopleAddTeamId < ActiveRecord::Migration
  def self.up
		add_column :people, :team_id, :integer
  end

  def self.down
		remove_column :people, :integer
  end
end
