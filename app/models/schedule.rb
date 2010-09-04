class Schedule < ActiveRecord::Base
  
  belongs_to :tournament

  has_many :rounds
  
  def round_robin
    rounds.destroy_all
    games_per_round = tournament.teams.size / 2
    rounds_no = tournament.teams.size - 1
    home = []
    away = []
    games_per_round.times do |i|
      home << tournament.teams[i]
      away << tournament.teams[2 * games_per_round - i - 1]
    end
    rounds_no.times do |i|
      round = Round.create :schedule_id => id
      games_per_round.times do |j|
        round.games << Game.create({ 
          :round => round,
          :home_team => home[j],
          :away_team => away[j]
        })
      end
      rounds << round
      rotate_teams(home, away)
    end
  end
  
  private 

    def rotate_teams(home, away)
      stable = home.shift
      home.unshift away.shift
      away.push home.pop
      home.unshift stable
    end
  
end
