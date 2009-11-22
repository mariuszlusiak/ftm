class Game < ActiveRecord::Base

  belongs_to :tournament
  belongs_to :game_slot
  belongs_to :home_team, :class_name => 'Team', :foreign_key => 'home_team_id'
  belongs_to :away_team, :class_name => 'Team', :foreign_key => 'away_team_id'
  has_one :game_result

  named_scope :unscheduled, :conditions => ['game_slot_id is null']

  def update_result(home_team_score, away_team_score, home_team_points, away_team_points)
    self.game_result ||= GameResult.new
    result = self.game_result
    result.home_team_score = home_team_score
    result.away_team_score = away_team_score
    result.home_team_points = home_team_points
    result.away_team_points = away_team_points
    result.finished = true
  end

end
