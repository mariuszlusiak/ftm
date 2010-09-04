class Round < ActiveRecord::Base
  
  belongs_to :schedule

  has_many :games
  
end
