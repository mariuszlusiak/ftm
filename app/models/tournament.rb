class Tournament < ActiveRecord::Base
	
	belongs_to :user

  has_one :tournament_type
  has_one :tournament_metadata

  has_many :tournament_teams
  has_many :teams, :through => :tournament_teams

end
