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
        d        = Dir.new(@directory)


        d.entries.each do |e|
          if correct_session_format?(e)
            sessions.push(e)
          end
        end

        sessions
      end

      def correct_session_format?(folder)
        if File.directory?(@directory + folder) && folder =~ /\A\d{4}\.\d{2}\.\d{2}\z/
          return true
        else
          return false
        end
      end
  end
end
