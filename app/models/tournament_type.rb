class TournamentType < ActiveRecord::Base

  belongs_to :tournament
  has_many :scheduling_algorithm_types
 
end
