module TeamsHelper

  def render_team_div(team)
    result = %{
      <div class='index-div team'>
        <span class='headline'>
        <span class='name'>#{h team.name}</span>
       </span>
    }
    unless team.city.blank?
      result += %{
        <span class='info'>Miejscowość: #{h team.city}</span>
      }
    end
    result += %{
     </div>
    }
  end
  
  def team_in_tournament_div(team, tournament)
    div_class = tournament.teams.include?(team) ? "index-div-highlighted" : "index-div"
    div_class << " team"
    %{
      <div class='#{div_class}'>
        <span class='headline'>
          <span class='name'>#{h team.name}</span>
        </span>
      </div>
    }
  end
  
end
