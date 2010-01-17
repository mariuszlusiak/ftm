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
  
end
