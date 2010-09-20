class TeamsController < ApplicationController
  # GET /teams
  # GET /teams.xml

  before_filter :login_required
  before_filter :find_tournament, :only => [:index, :manage_in_tournament,
    :toggle_in_tournament]

  def index
    if @tournament
      @teams = @tournament.teams
    else
      @teams = current_user.teams
    end
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /teams/1
  # GET /teams/1.xml
  def show
    @team = Team.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /teams/new
  # GET /teams/new.xml
  def new
    @team = Team.new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /teams/1/edit
  def edit
    @team = Team.find(params[:id])
		respond_to do |format|
			format.html # edit.html.erb
		end
  end
  
  # POST /teams
  # POST /teams.xml
  def create
		params[:team][:year_founded] = params[:team].delete(:"year_founded(1i)")
		params[:team].delete(:"year_founded(2i)")
		params[:team].delete(:"year_founded(3i)")
    @team = Team.new(params[:team])
		@team.user = current_user
		saved = @team.save
		flash[:notice] = 'Nowa drużyna została dodana' if saved
		continue = !params[:continue].nil?
    respond_to do |format|
			format.html do
				if saved and continue
					redirect_to new_team_path
      	elsif saved
      	  redirect_to team_path(@team)
      	else
      	  render :action => "new"
      	end
			end
    end
  end

  # PUT /teams/1
  # PUT /teams/1.xml
  def update
		params[:team][:year_founded] = params[:team].delete(:"year_founded(1i)")
		params[:team].delete(:"year_founded(2i)")
		params[:team].delete(:"year_founded(3i)")
    @team = Team.find(params[:id])
    respond_to do |format|
      format.html do
        if @team.update_attributes(params[:team])
          flash[:notice] = 'Dane drużyny zostały uaktualnione.'
          redirect_to team_path(@team)
        else
          render :action => "edit"
        end  
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.xml
  def destroy
    @team = Team.find(params[:id])
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_path }
    end
  end

	# not RESTful
	
	def manage_in_tournament
     @teams = current_user.teams
     respond_to do |format|
       format.html
     end
   end
	
	def toggle_in_tournament
	  team = Team.find params[:id]
	  if @tournament.teams.include? team
	    @tournament.teams.delete team
	    @tournament.game_slots.destroy_all
	    @tournament.schedule.destroy if @tournament.schedule
	  else  
	    @tournament.teams << team
	    @tournament.game_slots.destroy_all
	    @tournament.schedule.destroy if @tournament.schedule
	  end
	  @tournament.save
	  respond_to do |format|
	    format.js do
	      render :update do |page|
	        page.replace_html "team-in-tournament-#{team.id}",
	          render(:partial => "team_in_tournament", :object => team,
              :locals => { :tournament => @tournament })
	      end
	    end
	  end
	end
	
	def manage_players
		@team = Team.find(params[:id])
		respond_to do |format|
			format.html # manager_players.html.erb
		end
	end

	def add_player
		@team = Team.find(params[:id])
		if params[:player_id]
			player = Player.find(params[:player_id])
			if @team.players.include?(player)
				saved = false
			else
				@team.players << player
				saved = @team.save
			end
		else
			saved = false
		end
		respond_to do |format|
			format.js do
				if saved
					render :update do |page|
						page.replace_html 'team-players', :partial => 'players_list',
							:object => @team.players,
							:locals => { :title => "Zawodnicy drużyny #{@team.name}" }
						page.replace_html 'other-players', :partial => 'players_list',
							:object => current_user.players.free,
							:locals => { :title => "Zawodnicy bez drużyny" }
						page.replace_html 'other-team-players', :partial => 'players_list',
							:object => current_user.players.not_free_nor_in_team(@team),
							:locals => { :title => "Zawodnicy innych drużyn", :with_team => true }
						page['team-players'].visual_effect :highlight,
							:start_color => "#88ff88",
							:end_color => "#114411"
					end
				else
					render :nothing => true
				end
			end
		end
	end

	def remove_player
		@team = Team.find(params[:id])
		if params[:player_id]
			player = Player.find(params[:player_id])
			if @team.players.include?(player)
				@team.players.delete(player)
				player.team = nil
				saved = @team.save
				saved = saved && player.save
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
						page.replace_html 'team-players', :partial => 'players_list',
							:object => @team.players,
							:locals => { :title => "Zawodnicy drużyny #{@team.name}" }
						page.replace_html 'other-players', :partial => 'players_list',
							:object => current_user.players.free,
							:locals => { :title => "Zawodnicy bez drużyny" }
						page.replace_html 'other-team-players', :partial => 'players_list',
							:object => current_user.players.not_free_nor_in_team(@team),
							:locals => { :title => "Zawodnicy innych drużyn", :with_team => true }
						page['other-players'].visual_effect :highlight,
							:start_color => "#88ff88",
							:end_color => "#114411"
					end
				else
					render :nothing => true
				end
			end
		end
	end
	
	private
	
	  def find_tournament
	    if params[:tournament_id]
  	    @tournament = Tournament.find params[:tournament_id] 
  	    check_access_rights_to_resource @tournament
  	  end
	  end

end
