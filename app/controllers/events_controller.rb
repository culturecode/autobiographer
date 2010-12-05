class EventsController < ApplicationController
  def index
    @events = current_user.events.includes(:details)
  end
  
  def sync
    current_user.sync_events
    redirect_to :back
  end
end