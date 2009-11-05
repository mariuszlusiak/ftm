class Game < ActiveRecord::Base

  belongs_to :game_slot
  belongs_to :home_team, :class => :team, :foreign_key => 'home_team_id'
  belongs_to :away_team, :class => :team, :foreign_key => 'away_team_id'
  has_one :game_result

end
