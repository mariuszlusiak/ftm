class Game < ActiveRecord::Base

  belongs_to :tournament
  belongs_to :game_slot
  belongs_to :home_team, :class_name => 'Team', :foreign_key => 'home_team_id'
  belongs_to :away_team, :class_name => 'Team', :foreign_key => 'away_team_id'
  has_one :game_result

  named_scope :unscheduled, :conditions => ['game_slot_id is null']

end
