class SessionsController < ApplicationController
  before_filter :authorize,       :only => [:new, :destroy]
  before_filter :authorize_admin, :only => [:new, :create, :destroy]

  def index
    valid_options = ["by_session_date"]
    if valid_options.include? params[:sort]
      @sessions = Session.send(params[:sort])
      @sessions.reverse! if params[:reverse]
    else
      @sessions = Session.by_session_date.reverse
    end
    @title = "All sessions"
  end

  def new
    @title = "Add session"
    archive = SongsArchive::Directory.new(Pathname.new(PATHS['archive']))
    @new_files = files_in_archive_not_in_db(archive)
  end

  def create
    unless params.has_key? :sessions
      flash_message :notification, "Please select some files!"
      redirect_to new_session_path
      return
    end
    params[:sessions].each do |new_session, new_songs|
      session = Session.find_or_initialize_by_session_date(:session_date =>
                                            folder_name_to_date(new_session))
      new_songs.each { |song| session.songs.build(file_name: song) }
      if session.save
        flash_message :success, "Session #{new_session} saved!"
      else
        flash_message :error, "Session #{new_session} could not be saved!"
      end
    end
    redirect_to sessions_path
  end

  def destroy
    Session.find(params[:id]).destroy
    flash_message :notification, "You successfully deleted a session"
    redirect_to sessions_path
  end

  private

    def files_in_archive_not_in_db(archive)
      new_files = {}

      archive.sessions.each do |archive_session|
        new_files[archive_session] = []
        if session = Session.find_by_session_date(folder_name_to_date(archive_session))

          archive.files_in_session(archive_session).each do |archive_file|
            if Song.where(:file_name => archive_file,
                              :session_id => session.id).empty?
              new_files[archive_session].push(archive_file)
            end
          end
        else
          archive.files_in_session(archive_session).each do |archive_file|
            new_files[archive_session].push(archive_file)
          end
        end
      end
      new_files.delete_if { |s, f| f.empty? }
      return new_files
    end

    def folder_name_to_date(folder_name)
      Date.strptime(folder_name, "%Y.%m.%d")
    end
end
