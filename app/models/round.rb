class Round < ActiveRecord::Base
  
  has_many :games_slots
  has_many :games
  
  
end
