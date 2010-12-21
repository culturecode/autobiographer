class EventsController < ApplicationController
  def index
    @events = current_user.events.ascending.paginate(:page => params[:page], :per_page => 100, :include => :details)
  end
  
  def sync
    current_user.sync_events
    redirect_to :back
  end
  
  def hide
    current_user.events.update(params[:id], :hidden => true)
    respond_to do |format|
      format.html{ redirect_to :back }
      format.js{ render :nothing => true }
    end
  end
end