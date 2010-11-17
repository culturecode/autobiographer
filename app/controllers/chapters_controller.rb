class ChaptersController < ApplicationController
  def create
    Chapter.create!(:user_id => current_user.id, :title => 'New Chapter', :insert_before_event => params[:event_id])

    respond_to do |format|
      format.html{redirect_to :back}
      format.js{ @chapters = current_user.chapters.ascending }
    end

  end
  
  def destroy
    current_user.chapters.destroy(params[:id].to_i)
    
    respond_to do |format|
      format.html{redirect_to :back}
      format.js{ @chapters = current_user.chapters.ascending }
    end
    
  end
end