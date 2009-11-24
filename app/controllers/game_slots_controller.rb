class GameSlotsController < ApplicationController

  def inline_edit
    game_slot = GameSlot.find params[:id]
    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace_html "game-slot-#{game_slot.id}",
            render_game_slot(game_slot, true, false)
        end
      end
    end
  end

  def update
    game_slot = GameSlot.find params[:id]
    game_slot.update_attributes params[:game_slot]
    respond_to do |format|
      format.js do 
        render :update do |page|
          page.replace_html "game-slot-#{game_slot.id}",
            render_game_slot(game_slot, false, true)
        end
      end
    end
  end

end
