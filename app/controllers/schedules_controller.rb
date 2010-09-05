class SchedulesController < ApplicationController
  
  before_filter :login_required
  before_filter :find_tournament
  
  def show
    respond_to do |format|
      format.html
    end
  end
  
  def new
    @schedule = Schedule.new
    schedule_types = ["Pusty harmonogram", "Round-Robin", "Round-Robin 2", "Ftm"]
    @schedule_type_options = schedule_types.map { |i| "<option>#{i}</option>" }.join
    respond_to do |format|
      format.html
    end
  end
  
  def create
    @tournament.schedule.destroy if @tournament.schedule
    case params[:schedule_type]
    when "Pusty harmonogram"
      @tournament.empty_schedule
    when "Round-Robin"
      @tournament.schedule = Schedule.new
      @tournament.schedule.round_robin
      @tournament.fill_game_slots
    when "Round-Robin 2"
      @tournament.schedule = Schedule.new
      @tournament.schedule.round_robin_2
      @tournament.fill_game_slots
    when "Ftm"
      @tournament.schedule = Schedule.new
      @tournament.schedule.ftm
      @tournament.fill_game_slots
    end
    @tournament.save
    respond_to do |format|
      format.html { redirect_to tournament_schedule_path(@tournament) }
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
