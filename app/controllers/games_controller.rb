class GamesController < ApplicationController

  def update
    @game = Game.find params[:id]
    home_team_score = params[:home_team_score].to_i
    away_team_score = params[:away_team_score].to_i
    if params[:home_team_points] and params[:away_team_points]
      home_team_points = params[:home_team_points].to_i
      away_team_points = params[:away_team_point].to_i
    elsif home_team_score > away_team_score
      home_team_points = 3
      away_team_points = 0
    elsif home_team_score < away_team_score
      home_team_points = 0
      away_team_points = 3
    else
      home_team_points = 1
      away_team_points = 1
    end  
    @game.update_result home_team_score, away_team_score, home_team_points,
      away_team_points
    @game.game_result.save
    respond_to do |format|
      format.html { redirect_to(play_tournament_path(@game.tournament)) }
    end
  end

  def play
    @game = Game.find params[:id]
    if @game.game_result
      @home_team_score = @game.game_result.home_team_score
      @away_team_score = @game.game_result.away_team_score
      @home_team_points = @game.game_result.home_team_points
      @away_team_points = @game.game_result.away_team_points
    else
      @home_team_score = 0
      @away_team_score = 0
      @home_team_points = 0
      @away_team_points = 0
    end
    @use_default_pointing_system = @game.tournament.user.use_default_pointing_system
    respond_to do |format|
      format.html
    end
  end

end
