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

  def render_play_game(game)
    if game.game_slot
      result = render_game_slot game.game_slot
      if game.game_result and game.game_result.finished
        result += " #{game.game_result.home_team_score} : "
        result += "#{game.game_result.away_team_score}"
      end
      link_to result, play_game_path(game)
    else
      ''
    end
  end

end
