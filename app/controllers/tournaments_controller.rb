class TournamentsController < ApplicationController
	
  before_filter :login_required
  before_filter :find_tournament, :only => [:show, :edit, :update, :delete, :manage_type,
    :update_type, :manage_teams, :manage_fields, :play, :schedule,
    :generate_empty_schedule, :generate_round_robin_schedule, :add_team, :remove_team,
    :add_field, :remove_field]
  before_filter :find_game, :only => [:schedule_game]
  before_filter :find_game_slot, :only => [:schedule_game, :unschedule_game]
  before_filter :find_team, :only => [:add_team, :remove_team]
  before_filter :find_field, :only => [:add_field, :remove_field]
  
	
  def index
    @tournaments = current_user.tournaments
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @tournament = Tournament.new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @tournament = Tournament.find(params[:id])
  end

  def create
    @tournament = Tournament.new(params[:tournament])
		@tournament.user = current_user
		saved = @tournament.save
		flash[:notice] = 'Turniej został dodany' if saved
		continue = !params[:continue].nil?
    respond_to do |format|
			format.html do
				if saved and continue
					redirect_to manage_type_tournament_path(@tournament)
      	elsif saved
      	  redirect_to tournament_path(@tournament)
      	else
      	  render :action => "new"
      	end
			end
    end
  end

  def update
    respond_to do |format|
      if @tournament.update_attributes(params[:tournament])
        flash[:notice] = 'Dane turnieju zostały zaktualizowane.'
        format.html { redirect_to tournament_path(@tournament) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @tournament.destroy
    respond_to do |format|
      format.html { redirect_to tournaments_path }
    end
  end

  def manage_type
    if @tournament.tournament_metadata
      @metadata = @tournament.tournament_metadata
    else
      @metadata = TournamentMetadata.new
      @metadata.tournament = @tournament
      @metadata.save
    end
    respond_to do |format|
      format.html
    end
  end

  def update_type
    metadata = @tournament.tournament_metadata
    metadata.teams_count = params[:tournament_metadata][:teams_count].to_i
    metadata.games_count = params[:tournament_metadata][:games_count].to_i
    metadata.default_game_duration = 
      params[:tournament_metadata][:default_game_duration].to_i
    saved = metadata.save
    continue = !params[:continue].nil?
    respond_to do |format|
      format.html do
        if saved and continue
          redirect_to manage_teams_tournament_path(@tournament)
        elsif saved
          redirect_to tournament_path(@tournament)
        else
          render :action => 'manage_tournament_type'
        end
      end
    end
  end

  def manage_teams
    respond_to do |format|
      format.html
    end
  end

  def manage_fields
    respond_to do |format|
      format.html
    end
  end

  def play
    @table = Table.new @tournament.games
    respond_to do |format|
      format.html
    end
  end

  def schedule
    respond_to do |format|
      format.html
    end
  end

  def generate_empty_schedule
    @tournament.empty_schedule
    @tournament.save
    respond_to do |format|
      format.html do
        redirect_to schedule_tournament_path(@tournament)
      end
    end
  end

  def generate_round_robin_schedule
    @tournament.round_robin_schedule
    @tournament.save
    respond_to do |format|
      format.html do
        redirect_to schedule_tournament_path(@tournament)
      end
    end
  end

  def add_field
    if @tournament.fields.include? @field
      saved = false
    else
      @tournament.fields << @field
      saved = @tournament.save
    end
    respond_to do |format|
      format.js do 
        if saved
          render :update do |page|
            page.replace_html 'fields-in-tournament', :partial => 'fields',
              :object => @tournament.fields
            page.replace_html 'fields-not-in-tournament', :partial => 'fields',
              :object => @tournament.user.fields.all(:conditions => ['id not in (?)',
                ((@tournament.fields.collect { |f| f.id }) << -1)]
              )
            page['fields-in-tournament'].visual_effect :highlight,
              :start_color => '#88ff88',
              :end_color => '#114411'
          end
        else
          render :nothing => true
        end
      end
    end
  end

  def remove_field
    if @tournament.fields.include? @field
      @tournament.fields.delete @field
      @field.tournaments.delete @tournament
      saved = @tournament.save
      saved = saved && @field.save
    else
      saved = false
    end
    respond_to do |format|
      format.js do
        if saved
          render :update do |page|
            page.replace_html 'fields-in-tournament', :partial => 'fields',
              :object => @tournament.fields
            page.replace_html 'fields-not-in-tournament', :partial => 'fields',
              :object => @tournament.user.fields.all(:conditions => ['id not in (?)',
                ((@tournament.fields.collect { |f| f.id }) << -1)]
              )
            page['fields-not-in-tournament'].visual_effect :highlight,
              :start_color => '#88ff88',
              :end_color => '#114411'
          end
        else
          render :nothing => true
        end
      end
    end
  end

  def add_team
    if @tournament.teams.include? @team
      saved = false
    else
      @tournament.teams << @team
      saved = @tournament.save
    end
    respond_to do |format|
      format.js do
        if saved
          render :update do |page|
            page.replace_html 'teams-in-tournament', :partial => 'teams',
              :object => @tournament.teams
            page.replace_html 'teams-not-in-tournament', :partial => 'teams',
              :object => @tournament.user.teams.all(:conditions => ['id not in (?)',
                ((@tournament.teams.collect { |t| t.id }) << -1)]
              )
            page['teams-in-tournament'].visual_effect :highlight,
              :start_color => '#88ff88',
              :end_color => '#114411'
          end
        else
          render :nothing => true
        end
      end
    end
  end

  def remove_team
    if @tournament.teams.include? @team
      @tournament.teams.delete @team
      @team.tournaments.delete @tournament
      # TODO: rollback if one of the saves goes wrong
      saved = @tournament.save
      saved = saved && @team.save
    else
      saved = false
    end
    respond_to do |format|
      format.js do
        if saved
          render :update do |page|
            page.replace_html 'teams-in-tournament', :partial => 'teams',
              :object => @tournament.teams
            page.replace_html 'teams-not-in-tournament', :partial => 'teams',
              :object => @tournament.user.teams.all(:conditions => ['id not in (?)',
                ((@tournament.teams.collect { |t| t.id }) << -1)]
              )
            page['teams-not-in-tournament'].visual_effect :highlight,
              :start_color => '#88ff88',
              :end_color => '#114411'
          end
        else
          render :nothing => true
        end
      end
    end
  end
  
  def schedule_game
    game = Game.find params[:game_id]
    game_slot = GameSlot.find params[:game_slot_id]
    game_slot.game = nil
    game.game_slot = game_slot
    game_slot.save
    saved = game.save
    respond_to do |format|
      format.js do
        if saved 
          render :update do |page|
            page.replace_html 'game-slots', render(:partial => 'game_slots',
              :object => game_slot.tournament.game_slots,
              :locals => { :enable_drag_n_drop => true, :enable_edit => true })
            page.replace_html 'games', render(:partial => 'games',
              :object => game_slot.tournament.games.unscheduled,
              :locals => { :enable_drag_n_drop => true })
          end
        end
      end
    end
  end

  def unschedule_game
    game_slot = GameSlot.find params[:game_slot_id]
    game_slot.game = nil
    game_slot.save
    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace_html 'game-slots', render(:partial => 'game_slots',
            :object => game_slot.tournament.game_slots,
            :locals => { :enable_drag_n_drop => true, :enable_edit => true })
          page.replace_html 'games', render(:partial => 'games',
            :object => game_slot.tournament.games.unscheduled,
            :locals => { :enable_drag_n_drop => true })
        end
      end
    end
  end

  private

    def find_tournament
      @tournament = Tournament.find params[:id]
      check_access_rights_to_resource @tournament
    end

    def find_game
      @game = Game.find params[:game_id]
      check_access_rights_to_resource @game.tournament
    end

    def find_game_slot
      @game_slot = GameSlot.find params[:game_slot_id]
      check_access_rights_to_resource @game_slot.tournament
    end

    def find_team
      @team = Team.find params[:team_id]
      check_access_rights_to_resource @team
    end

    def find_field
      @field = Field.find params[:field_id]
      check_access_rights_to_resource @field
    end

end
