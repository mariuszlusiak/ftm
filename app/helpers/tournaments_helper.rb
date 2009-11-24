module TournamentsHelper

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
