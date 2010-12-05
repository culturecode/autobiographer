class NotesController < ApplicationController
  before_filter :find_note, :only => [:update, :destroy]
  before_filter :check_notable_owner, :only => [:create, :update]

  def create
    Note.create!(params[:note])
    respond_to do |format|
      format.html{ redirect_to :back }
      format.js{ render 'events/index.js.erb' }
    end
  end

  def destroy
    @note.destroy

    respond_to do |format|
      format.html{ redirect_to :back }
      format.js{ render 'events/index.js.erb' }
    end

  end

  def update
    @note.update_attributes!(params[:note])

    respond_to do |format|
      format.html{ redirect_to :back }
      format.js{ render :nothing => true }
    end

  end

  private

  def find_note
    @note = Note.find(params[:id])
  end

  # checks if the current_user is the owner of the thing they're attaching a note to
  def check_notable_owner
    Note.new(params[:note]).notable.user == current_user
  end
end