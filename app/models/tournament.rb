class Tournament < ActiveRecord::Base
	
	belongs_to :user

  has_one :schedule

  has_many :tournament_teams
  has_many :teams, :through => :tournament_teams
  has_many :tournament_fields
  has_many :fields, :through => :tournament_fields
  has_many :game_slots


  def empty_schedule
    game_slots.destroy_all
    (teams.size * (teams.size - 1) / 2).times do 
      game_slot = GameSlot.create :tournament => self,
        :start => start_date.to_datetime,
        :end => start_date.to_datetime + DEFAULT_GAME_DURATION.minutes,
        :field => fields.first
      game_slots << game_slot
    end
  end
  
  def fill_game_slots
    if schedule
      game_slots_index = 0
      schedule.rounds.each do |r|
        r.games.each do |g|
          game_slots[game_slots_index].game = g
          g.game_slot = game_slots[game_slots_index]
          game_slots_index += 1
        end
      end
    end
  end

  def round_robin_ftm_schedule
    if self.fields.size > 0 and self.teams.size == self.tournament_metadata.teams_count
      self.empty_schedule
      self.games.destroy_all
      teams_count = self.teams.size
      games_count = self.game_slots.count
      games_per_round = teams_count / 2
      rounds = self.game_slots.size / games_per_round
      for game_no in 0..games_count - 1
        round = game_no / games_per_round
        k1 = game_no - round * games_per_round
        k2 = teams_count - 1 - k1
        home_team = self.teams[round_robin_permutation teams_count, round, k1]
        away_team = self.teams[round_robin_permutation teams_count, round, k2]
        current_game = create_game home_team, away_team
        current_game.game_slot = self.game_slots[game_no]
        current_game.tournament = self
        current_game.save
      end
    end
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

  def create_game(home_team, away_team)
    game = Game.new
    game.home_team = home_team
    game.away_team = away_team
    game
  end

  def benchmark
    Benchmark.bm(10) do |x|
      x.report("round robin ftm schedule") do
        self.round_robin_ftm_schedule
      end
      x.report("round robin schedule") do
        self.round_robin_schedule
      end
    end
  end

end
