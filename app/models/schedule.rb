class Schedule < ActiveRecord::Base
  
  has_many :rounds
  
  def round_robin(teams)
    self.rounds.destroy_all
    games_per_round_count = teams.size / 2
    rounds_count = teams.size - 1
    home = []
    away = []
    games_per_round_count.times do |i|
      home << teams[i]
      away << teams[2 * games_per_round_count - i - 1]
    end
    rounds_count.times do |i|
      round = Round.create :schedule_id => id
      games_per_round_count.times do |j|
        
      end
      
    end
  end
  
end
