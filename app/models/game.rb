class Game < ActiveRecord::Base

  belongs_to :tournament
  belongs_to :game_slot
  belongs_to :home_team, :class_name => 'Team', :foreign_key => 'home_team_id'
  belongs_to :away_team, :class_name => 'Team', :foreign_key => 'away_team_id'
  has_one :game_result

  def initialize(home_team_id, away_team_id)
    super
    self.home_team_id = home_team_id
    self.away_team_id = away_team_id
  end

end
