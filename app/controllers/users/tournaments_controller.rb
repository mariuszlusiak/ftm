class Users::TournamentsController < ApplicationController
  # GET /tournaments
  # GET /tournaments.xml
	
	before_filter :find_user
	before_filter :kick_not_current_user_or_admin
	
  def index
    @tournaments = @user.tournaments
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /tournaments/1
  # GET /tournaments/1.xml
  def show
    @tournament = Tournament.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /tournaments/new
  # GET /tournaments/new.xml
  def new
    @tournament = Tournament.new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /tournaments/1/edit
  def edit
    @tournament = Tournament.find(params[:id])
  end

  # POST /tournaments
  # POST /tournaments.xml
  def create
    @tournament = Tournament.new(params[:tournament])
		@tournament.user = @user
		saved = @tournament.save
		flash[:notice] = 'Turniej został dodany' if saved
		continue = !params[:continue].nil?
    respond_to do |format|
			format.html do
				if saved and continue
					redirect_to manage_type_user_tournament_path(@user, @tournament)
      	elsif saved
      	  redirect_to user_tournament_path(@user, @tournament)
      	else
      	  render :action => "new"
      	end
			end
    end
  end

  # PUT /tournaments/1
  # PUT /tournaments/1.xml
  def update
    @tournament = Tournament.find(params[:id])
    respond_to do |format|
      if @tournament.update_attributes(params[:tournament])
        flash[:notice] = 'Dane turnieju zostały zaktualizowane.'
        format.html { redirect_to user_tournament_path(@user, @tournament) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /tournaments/1
  # DELETE /tournaments/1.xml
  def destroy
    @tournament = Tournament.find(params[:id])
    @tournament.destroy
    respond_to do |format|
      format.html { redirect_to user_tournaments_path(@user) }
    end
  end

  def manage_type
    @tournament = Tournament.find params[:id]
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
    @tournament = Tournament.find params[:id]
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
          redirect_to manage_teams_user_tournament_path(@user, @tournament)
        elsif saved
          redirect_to user_tournament_path(@user, @tournament)
        else
          render :action => 'manage_tournament_type'
        end
      end
    end
  end

  def manage_teams
    @tournament = Tournament.find params[:id]
    respond_to do |format|
      format.html
    end
  end

  def update_teams
    @tournament = Tournament.find params[:id]
    # TODO: update tournament teams
    saved = true
    continue = !params[:continue].nil?
    respond_to do |format|
      format.html do
        if saved and continue
          redirect_to schedule_user_tournament_path(@user, @tournament)
        elsif saved
          redirect_to user_tournament_path(@user, @tournament)
        else
          render :action => 'manage_tournanment_teams'
        end
      end
    end
  end

  def schedule
    @tournament = Tournament.find params[:id]
    respond_to do |format|
      format.html
    end
  end

  def update_schedule
    @tournament = Tournament.find params[:id]
    # TODO: update tournament schedule
    saved = true
    respond_to do |format|
      format.html do 
        if saved
          redirect_to user_tournament_path(@user, @tournament)
        else
          render :action => 'schedule_tournament'
        end
      end
    end
  end

  def add_team
    @tournament = Tournament.find params[:id]
    if params[:team_id]
      team = Team.find params[:team_id]
      if @tournament.teams.include? team
        saved = false
      else
        @tournament.teams << team
        saved = @tournament.save
      end
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
              :object => Team.all(:conditions => ['id not in (?)',
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
    @tournament = Tournament.find params[:id]
    if params[:team_id]
      team = Team.find params[:team_id]
      if @tournament.teams.include? team
        @tournament.teams.delete team
        team.tournaments.delete @tournament
        # TODO: rollback if one of the saves goes wrong
        saved = @tournament.save
        saved = saved && team.save
      else
        saved = false
      end
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
              :object => Team.all(:conditions => ['id not in (?)',
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

	private

	def find_user
		@user = User.find(params[:user_id])
	end

end
