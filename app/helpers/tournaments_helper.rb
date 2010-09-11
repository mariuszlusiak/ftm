module TournamentsHelper
  
  def render_schedule(tournament)
    render :partial => "/tournaments/schedule", :object => tournament
  end

  def render_tournament_div(tournament)
    result = %{
      <div class='index-div tournament'>
      <span class='headline'>
        <span class='name'>#{h tournament.name}</span>
      </span> 
    }
    if tournament.start_date and tournament.end_date
      result += %{
        <span class='info'>Od: #{h tournament.start_date}</span>
        <span class='info'>Do: #{h tournament.end_date}</span>
      }
    end
    unless tournament.organizer.blank?
      result += %{
        <span class='info'>Zorganizowany przez: #{h tournament.organizer}</span>
      }
    end
    result += %{
      </div>
    }
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
