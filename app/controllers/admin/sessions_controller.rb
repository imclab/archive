class Admin::SessionsController < Admin::BaseController
  def new
    @new_files = files_in_archive_not_in_db
  end

  def index
    @sessions = Session.includes(songs: [:comments, :tags]).order('session_date')
  end

  def create
    unless params.has_key? :sessions
      flash_message :notification, "Please select some files!"
      redirect_to new_admin_session_path
      return
    end

    params[:sessions].each do |new_session, new_songs|
      if build_new_session(new_session, new_songs).save
        flash_message :success, "Session #{new_session} saved!"
        expire_fragment('all_sessions_with_songs')
      else
        flash_message :error, "Session #{new_session} could not be saved!"
      end
    end
    redirect_to admin_sessions_path
  end

  def destroy
    Session.find(params[:id]).destroy

    expire_fragment('all_sessions_with_songs')

    flash_message :notification, "You successfully deleted a session"
    redirect_to sessions_path
  end
  
  private

    def archive
      @archive ||= SongsArchive::Directory.new(Pathname.new(PATHS['archive']))
    end

    def build_new_session(session, songs)
      session = Session.find_or_initialize_by_session_date(session_date: folder_name_to_date(session))
      songs.each { |song| session.songs.build(file_name: song) }
      session
    end

    def files_in_archive_not_in_db
      new_files = {}

      archive.sessions.each do |archive_session|
        new_files[archive_session] = new_files_for_session(archive_session)
      end

      new_files.reject { |session, files| files.empty? }
    end

    def new_files_for_session(archive_session)
      files   = []
      session = Session.find_by_session_date(folder_name_to_date(archive_session))

      archive.files_in_session(archive_session).each do |archive_file|
        if !session || session.songs.where(file_name: archive_file).empty?
          files.push(archive_file)
        end
      end

      files
    end

    def folder_name_to_date(folder_name)
      Date.strptime(folder_name, "%Y.%m.%d")
    end
end
