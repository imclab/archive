#
# Module SongsArchive
#
# Directory - scans the specified folder for audio files
# in session folders

module SongsArchive
  class Directory
    def initialize(dir)
      @directory = Pathname.new(dir)
    end


    def sessions
     @sessions ||= scan_for_sessions
    end

    def files_in_session(session)
      files = []
      Dir.glob(@directory + session + "*.{mp3,flac,wav}").each do |f|
        files.push(f.split("/").last)
      end

      files
    end

    private

      def scan_for_sessions
        sessions = []
        dir      = Dir.new(@directory)

        dir.entries.each do |entry|
          sessions.push(entry) if correct_session_format?(entry)
        end

        sessions
      end

      def correct_session_format?(folder)
        File.directory?(@directory + folder) && folder =~ /\A\d{4}\.\d{2}\.\d{2}\z/
      end
  end
end
