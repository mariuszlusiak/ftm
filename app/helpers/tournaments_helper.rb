module TournamentsHelper

  def render_game_slot(game_slot)
    result = ''
    result += game_slot.start.strftime("%Y-%m-%d")
    result += ' '
    result += game_slot.start.strftime("%H:%M")
    result += ' '
    result += game_slot.end.strftime("%H:%M")
    if game_slot.game
      result += "#{game_slot.game.home_team.name} - #{game_slot.game.away_team.name}"
    else
      result += " _ _ _ _ _ - _ _ _ _ _"
    end
    result
  end

  def render_game(game)
    "#{game.home_team.name} - #{game.away_team.name}"
  end

end
