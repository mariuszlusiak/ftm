require "graph"

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
  
  def round_robin_2
    rounds.destroy_all
    teams_no = tournament.teams.size
    games_no = teams_no * (teams_no - 1) / 2
    games_per_round = tournament.teams.size / 2
    for game_no in 0...games_no
      round_no = game_no / games_per_round
      rounds << Round.new if round_no == rounds.size
      round = rounds.last
      k1 = game_no - round_no * games_per_round
      k2 = teams_no - 1 - k1
      home_team = tournament.teams[round_robin_permutation(teams_no, round_no, k1)]
      away_team = tournament.teams[round_robin_permutation(teams_no, round_no, k2)]
      round.games << Game.new(:home_team => home_team, :away_team => away_team)
    end
  end
  
  def ftm
    rounds.destroy_all
    self.rounds = ftm_proc tournament.teams
  end
  
  private 

    def rotate_teams(home, away)
      stable = home.shift
      home.unshift away.shift
      away.push home.pop
      home.unshift stable
    end
    
    def round_robin_permutation(teams_count, r, k)
      if k == 0
        return 0
      elsif k <= r
        return teams_count - r + k - 1
      else
        return k - r 
      end
    end
    
    def ftm_proc(teams)
      if teams.size == 2
        r = Round.new
        r.games << Game.new(:home_team => teams.first, :away_team => teams.last)
        return [r]
      end
      bottom, top = split_array(teams)
      if bottom.size % 2 > 0
        fake_team_1 = Team.new :name => "Fake 1"
        fake_team_2 = Team.new :name => "Fake 2"
        bottom << fake_team_1
        top.unshift(fake_team_2)
      end
      bottom_rounds = ftm_proc(bottom)
      top_rounds = ftm_proc(top)
      all_rounds = []
      skip_games = []
      bottom_rounds.size.times do |i|
        r = bottom_rounds[i] + top_rounds[i]
        if bottom.last == fake_team_1
          fake_games = r.games.select do |g|
            (g.teams & [fake_team_1, fake_team_2]).size > 0
          end
          r.games = r.games - fake_games
          pause_teams = []
          fake_games.each do |g|
            pause_teams << (g.teams - [fake_team_1, fake_team_2]).first
          end
          merged_game = Game.new :home_team => pause_teams.first,
            :away_team => pause_teams.last
          r.games << merged_game
          skip_games << merged_game
        end
        all_rounds << r
      end
      ftm_merge(bottom - [fake_team_1], top - [fake_team_2], skip_games) + all_rounds
    end
    
    def ftm_merge(bottom, top, skip_games = [])
      result = []
      g = Graph.new
      left = []
      right = []
      bottom.each do |t|
        v = Vertex.new t
        g.add_vertex v
        left << v
      end
      top.each do |t|
        v = Vertex.new t
        g.add_vertex v
        right << v
      end
      bottom.each do |t1|
        top.each do |t2|
          if skip_games.find { |game| game.home_team == t1 and game.away_team == t2 }.nil?
            g.add_edge Edge.new(g.find(t1), g.find(t2))
          end
        end
      end
      matching = g.max_matching(left, right)
      while matching.length > 0
        round = Round.new
        matching.each do |m|
          round.games << Game.new(:home_team => m.first.obj, :away_team => m.last.obj)
          g.edges[m.first].delete_if { |e| e.to == m.last }
        end
        result << round
        matching = g.max_matching(left, right)
      end
      result
    end
    
    def split_array(ar)
      pivot = ar.size / 2
      [ar[0..pivot-1], ar[pivot..ar.size-1]]
    end
  
end