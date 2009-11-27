class TournamentField < ActiveRecord::Base

  belongs_to :tournament
  belongs_to :field

end
