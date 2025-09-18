class NotesController < ApplicationController
  def index
    @notes =
      @current_user&.organizations&.includes(:notes)&.flat_map(&:notes)&.uniq
  end

  def show
    @note = Note.find(params[:id])

    @notes =
      @current_user&.organizations&.includes(:notes)&.flat_map(&:notes)&.uniq
  end

  def download
    note = Note.find(params[:id])

    send_data note.body,
      filename: "#{note.title}.md",
      type: "text/plain",
      disposition: "attachment"
  end

  def new
    @note = Note.new
  end

  def create
    @note = Note.new(note_params)
    
    # Set the organization if provided
    if params[:note][:organization_id].present?
      organization = Organization.find_by(id: params[:note][:organization_id])
      
      if organization.nil? || !@current_user.organizations.include?(organization)
        redirect_to new_note_path, alert: "Please select a valid organization you have access to."
        return
      end
      
      @note.organization = organization
    else
      redirect_to new_note_path, alert: "Please select an organization."
      return
    end

    if @note.save
      redirect_to @note, notice: "Note was successfully created."
    else
      render :new
    end
  end

  def edit
    @note = Note.find_by(id: params[:id])
    
    unless @note && @current_user.organizations.include?(@note.organization)
      redirect_to notes_path, alert: "Note not found or you don't have permission to edit it."
      return
    end

    @notes = @current_user.organizations.includes(:notes).flat_map(&:notes).uniq
  end

  def update
    @note = Note.find(params[:id])
    if @note.update(note_params)
      redirect_to @note, notice: "Note was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @note = Note.find(params[:id])
    @note.destroy
    redirect_to notes_url, notice: "Note was successfully destroyed."
  end

  private

  def note_params
    params.require(:note).permit(:title, :body, :organization_id)
  end
end
