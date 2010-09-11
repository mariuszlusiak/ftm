module SchedulesHelper

  def render_schedule(schedule)
    render :partial => "schedule", :object => schedule
  end

end
