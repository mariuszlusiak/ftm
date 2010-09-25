class PlayersController < ApplicationController	
  before_filter :login_required

  def index
		page = params[:page] || 1
		@players = current_user.players.paginate(:page => page, :per_page => PLAYERS_PER_PAGE)
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /players/1
  # GET /players/1.xml
  def show
    @player = Player.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /players/new
  # GET /players/new.xml
  def new
    @player = Player.new
		@positions = find_positions
		@teams = find_teams
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /players/1/edit
  def edit
    @player = Player.find(params[:id])
		@positions = find_positions
		@teams = find_teams
		respond_to do |format|
			format.html # edit.html.erb
		end
  end

  # POST /players
  # POST /players.xml
  def create
		avatar = Avatar.new(params[:avatar])
		avatar_saved = avatar.save
    @player = Player.new(params[:player])
		@player.user = current_user
		if avatar_saved
			@player.avatar = avatar
		end
		saved = @player.save
		flash[:notice] = 'Zawodnik został dodany' if saved
		continue = !params[:continue].nil?
		respond_to do |format|
			format.html do
				if saved and continue
					redirect_to new_player_path
				elsif saved
      	  redirect_to player_path(@player)
      	else
      	  render :action => "new"
      	end
			end
    end
  end

  # PUT /players/1
  # PUT /players/1.xml
  def update
    @player = Player.find(params[:id])
    respond_to do |format|
      if @player.update_attributes(params[:player])
        flash[:notice] = 'Dane zawodnika zostały uaktualnione.'
        format.html { redirect_to player_path(@player) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /players/1
  # DELETE /players/1.xml
  def destroy
    @player = Player.find(params[:id])
    @player.destroy
    respond_to do |format|
      format.html { redirect_to(players_path) }
			format.js do
				render :update do |page|
					page.replace_html "player-#{@player.id}", ''
				end
			end
    end
  end

	def avatar
		@player = Player.find(params[:id])
		respond_to do |format|
			format.html
		end
	end

	def add_avatar
		avatar = Avatar.new(params[:avatar])
		avatar_saved = avatar.save
    @player = Player.find(params[:id])
		if avatar_saved
			@player.avatar = avatar
		end
		saved = @player.save
		respond_to do |format|
			format.html { redirect_to player_url(@player) }
    end

	end

	def remove_avatar
		@player = Player.find(params[:id])
		av = @player.avatar
		av.destroy if av
		@player.avatar = nil
		@player.save
		respond_to do |format|
			format.js do
				render :update do |page|
					page.replace_html 'avatar', render(:partial => 'avatar', :object => @player)
				end
			end
		end
	end

	private

	def find_positions
		positions = { 'Brak' => nil }
		Position.all.each do |p|
			positions[p.description] = p.id
		end
		positions
	end

	def find_teams
		teams = { 'Brak' => nil }
		current_user.teams.each do |t|
			teams[t.name] = t.id
		end
		teams
	end

end
