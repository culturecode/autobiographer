class EventsController < ApplicationController
  def index
    @chapters = current_user.chapters
  end
  
  def sync
    current_user.sync_events
    redirect_to :back
  end
end