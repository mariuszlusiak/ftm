class GameResult < ActiveRecord::Base

  belongs_to :game

  has_many :goals

end
