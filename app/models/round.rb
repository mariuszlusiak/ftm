class Round < ActiveRecord::Base
  
  belongs_to :schedule

  has_many :games
  
  def +(other)
    result = Round.new
    result.games += @games
    result.games += other.games
    result
  end
  
end
