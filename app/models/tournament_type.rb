class TournamentType < ActiveRecord::Base

  has_many :tournaments
  has_many :scheduling_algorithm_types
 
end
