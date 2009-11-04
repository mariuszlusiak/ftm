class Team < ActiveRecord::Base

	belongs_to :user

	has_many :players
	has_many :people
  has_many :tournament_teams
  has_many :tournaments, :through => :tournament_teams


end
