class NotesController < ApplicationController
  before_filter :find_note, :only => [:update, :destroy]
  
  def create
    Note.create!(:user_id => current_user.id, :insert_before_event => params[:event_id])

    respond_to do |format|
      format.html{redirect_to :back}
      format.js{ render 'events/index.js.erb' }
    end

  end
  
  def destroy
    @note.destroy
    
    respond_to do |format|
      format.html{redirect_to :back}
      format.js{ render 'events/index.js.erb' }
    end
    
  end
  
  def update
    @note.update_attributes!(params[:note])

    respond_to do |format|
      format.html{redirect_to :back}
      format.js{ render :nothing => true }
    end

  end
  
  private
  
  def find_note
    # HACK: Polymorphic through relations returns readonly records...
    @note = current_user.notes.find(params[:id], :readonly => false)
  end
end