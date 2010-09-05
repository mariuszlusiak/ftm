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

end
