module GameSlotsHelper

  def render_game_slot(game_slot, edit = false, enable_edit = false)
    result = ''
    if enable_edit
      result += '['
      result += link_to_remote('edytuj', :url => inline_edit_game_slot_path(game_slot))
      result += '] '
    end
    if edit
      form_elements = ''
      form = remote_form_for(game_slot) do |f|
        form_elements += f.submit 'Zapisz'
        form_elements += f.calendar_date_select(:start, :size => 13)
        form_elements += f.calendar_date_select(:end, :size => 13)
        form_elements += f.select(:field_id,
          game_slot.tournament.fields.collect { |f| [ f.name, f.id ] }
        )
      end
      result += form[0]
      result += form_elements
      result += form[1]
    else
      result += game_slot.field.name
      result += ' '
      result += game_slot.start.strftime("%Y-%m-%d")
      result += ' '
      result += game_slot.start.strftime("%H:%M")
      result += ' '
      result += game_slot.end.strftime("%H:%M")
    end
    result += ' '
    if game_slot.game
      result += "#{game_slot.game.home_team.name} - #{game_slot.game.away_team.name}"
    else
      result += " _ _ _ _ _ - _ _ _ _ _"
    end
    result
  end

end
