class Tournament < ActiveRecord::Base
	
	belongs_to :user
  belongs_to :tournament_type

  has_one :tournament_metadata

  has_many :game_slots
  has_many :games
  has_many :tournament_teams
  has_many :teams, :through => :tournament_teams

  # Creates games and game slots. This is an entry point for scheduling a tournament.
  def empty_schedule
    self.game_slots.destroy_all
    self.games.destroy_all
    teams_count = self.tournament_metadata.teams_count
    games_same_teams_count = self.tournament_metadata.games_count
    games_count = games_same_teams_count * teams_count * (teams_count - 1) / 2
    games_count.times do
      game_slot = GameSlot.new
      game_slot.start = self.start_date.to_datetime
      game_slot.end = game_slot.start + self.tournament_metadata.default_game_duration.minutes
      self.game_slots << game_slot
    end
    i = 0
    while i < teams_count
      j = i + 1
      while j < teams_count
        games_same_teams_count.times do
          self.games << create_game(teams[i], teams[j])
        end
        j += 1
      end
      i += 1
    end
  end

  # Creates games and games slots using round-robin algorithm.
  # TODO: currently assuming even number of teams, improve this!
  def round_robin_schedule
    self.empty_schedule
    self.games.destroy_all
    teams_count = self.teams.size
    games_count = self.game_slots.count
    games_per_round = teams_count / 2
    rounds = self.game_slots.size / games_per_round
    home = []
    away = []
    for i in 0..games_per_round - 1
      home << self.teams[i]
      away << self.teams[2 * games_per_round - i - 1]
    end
    for i in 0..rounds - 1
      for j in 0..games_per_round - 1
        current_game = create_game home[j], away[j]
        current_game.game_slot = self.game_slots[games_per_round * i + j]
        current_game.tournament = self
        current_game.save
      end
      rotate_teams home, away
    end
  end

  def rotate_teams(home, away)
    stable = home.shift
    home.unshift away.shift
    away.push home.pop
    home.unshift stable
  end

  def create_game(home_team, away_team)
    game = Game.new
    game.home_team = home_team
    game.away_team = away_team
    game
  end

end
