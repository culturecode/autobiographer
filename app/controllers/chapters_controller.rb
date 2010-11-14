class ChaptersController < ApplicationController
  def create
    current_user.chapters.create!(:title => 'New Chapter', :timestamp => DateTime.parse(params[:timestamp]))

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