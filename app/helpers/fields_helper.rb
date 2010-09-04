module FieldsHelper

  def render_field_div(field)
    result = %{
      <div class='index-div field'>
        <span class='headline'>
          <span class='name'>#{h field.name}</span>
        </span>
    }
    unless field.description.blank?
      result += %{
        <span class='info'>#{h truncate(field.description, 200)}</span>
      }
    end
    result += %{
      </div>
    }
    result
  end
  
  def field_in_tournament_div(field, tournament)
    div_class = tournament.fields.include?(field) ? "index-div-highlighted" : "index-div"
    div_class << " field"
    %{
      <div class='#{div_class}'>
        <span class='headline'>
          <span class='name'>#{h field.name}</span>
        </span>
      </div>
    }
  end
  
end
