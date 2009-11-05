class Tournament::GameSlotsController < ApplicationController
  # GET /tournament_game_slots
  # GET /tournament_game_slots.xml
  def index
    @tournament_game_slots = Tournament::GameSlot.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tournament_game_slots }
    end
  end

  # GET /tournament_game_slots/1
  # GET /tournament_game_slots/1.xml
  def show
    @game_slot = Tournament::GameSlot.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @game_slot }
    end
  end

  # GET /tournament_game_slots/new
  # GET /tournament_game_slots/new.xml
  def new
    @game_slot = Tournament::GameSlot.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @game_slot }
    end
  end

  # GET /tournament_game_slots/1/edit
  def edit
    @game_slot = Tournament::GameSlot.find(params[:id])
  end

  # POST /tournament_game_slots
  # POST /tournament_game_slots.xml
  def create
    @game_slot = Tournament::GameSlot.new(params[:game_slot])

    respond_to do |format|
      if @game_slot.save
        flash[:notice] = 'Tournament::GameSlot was successfully created.'
        format.html { redirect_to(@game_slot) }
        format.xml  { render :xml => @game_slot, :status => :created, :location => @game_slot }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @game_slot.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tournament_game_slots/1
  # PUT /tournament_game_slots/1.xml
  def update
    @game_slot = Tournament::GameSlot.find(params[:id])

    respond_to do |format|
      if @game_slot.update_attributes(params[:game_slot])
        flash[:notice] = 'Tournament::GameSlot was successfully updated.'
        format.html { redirect_to(@game_slot) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @game_slot.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tournament_game_slots/1
  # DELETE /tournament_game_slots/1.xml
  def destroy
    @game_slot = Tournament::GameSlot.find(params[:id])
    @game_slot.destroy

    respond_to do |format|
      format.html { redirect_to(tournament_game_slots_url) }
      format.xml  { head :ok }
    end
  end
end
