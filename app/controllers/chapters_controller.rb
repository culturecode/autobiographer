class ChaptersController < ApplicationController
  before_filter :find_chapter, :only => [:update, :destroy]
  def create
    Chapter.create!(:user_id => current_user.id, :title => "New Chapter", :insert_before_event => params[:event_id])

    respond_to do |format|
      format.html{redirect_to :back}
      format.js{ @chapters = current_user.chapters.ascending }
    end

  end
  
  def destroy
    @chapter.destroy
    
    respond_to do |format|
      format.html{redirect_to :back}
      format.js{ @chapters = current_user.chapters.ascending }
    end
    
  end
  
  def update
    @chapter.update_attributes!(params[:chapter])

    respond_to do |format|
      format.html{redirect_to :back}
      format.js{ render :nothing => true }
    end

  end
  
  private
  
  def find_chapter
    @chapter = current_user.chapters.find(params[:id])
  end
end