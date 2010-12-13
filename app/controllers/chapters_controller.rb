class ChaptersController < ApplicationController
  before_filter :find_chapter, :only => [:update, :destroy]
  def create
    @chapter = Chapter.new(:user => current_user, :title => "New Chapter", :insert_before_event => params[:event_id])
    @chapter.save!

    respond_to do |format|
      format.html{redirect_to :back}
      format.js
    end

  end
  
  def destroy
    @chapter.destroy
    
    respond_to do |format|
      format.html{redirect_to :back}
      format.js
    end
    
  end
  
  def update
    @chapter.update_attributes!(params[:chapter])

    respond_to do |format|
      format.html{redirect_to :back}
      format.js{ render 'chapters/index.js.erb' }
    end
  end
  
  private
  
  def find_chapter
    # HACK: Polymorphic through relations returns readonly records...
    @chapter = current_user.chapters.find(params[:id], :readonly => false)
  end
end