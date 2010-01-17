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

end
