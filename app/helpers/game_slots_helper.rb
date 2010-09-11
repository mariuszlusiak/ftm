module GameSlotsHelper

  def render_game_slot(game_slot, edit = false, enable_edit = false)
    result = ''
    if game_slot.game
      result << "#{game_slot.game.home_team.name} - #{game_slot.game.away_team.name} "
    else
      result << " _ _ _ _ _ _ _ - _ _ _ _ _ _ _ "
    end
    
    if edit
      result << render(:partial => "/shared/game_slot_editable", :object => game_slot)
    else
      result += game_slot.field.name
      result += ' '
      result += game_slot.start.strftime("%Y-%m-%d")
      result += ' '
      result += game_slot.start.strftime("%H:%M")
      result += ' '
      result += game_slot.end.strftime("%H:%M")
    end
    if enable_edit
      result += '['
      result += link_to_remote('edytuj', :url => inline_edit_game_slot_path(game_slot))
      result += '] '
    end
    result
  end

end
