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
    self.game_slots.clear
    self.games.clear
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
          game = Game.new
          game.home_team = teams[i]
          game.away_team = teams[j]
          self.games << game
        end
        j += 1
      end
      i += 1
    end
  end



end
