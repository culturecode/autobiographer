class EventsController < ApplicationController
  def index
    @chapters = User.first.chapters
  end
end