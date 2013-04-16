module SongsArchive
  class Directory
    def initialize(dir)
      @directory = Pathname.new(dir)
    end

    def sessions
     @sessions ||= scan_for_sessions
    end

    def files_in_session(session)
      pattern = @directory + session + "*.{mp3,flac,wav}"
      Dir.glob(pattern).map {|f| File.basename(f) }
    end

    private

      def scan_for_sessions
        Dir.new(@directory).entries.select {|entry| session_dir?(entry) }
      end

      def session_dir?(folder)
        File.directory?(@directory + folder) && folder =~ /\A\d{4}\.\d{2}\.\d{2}\z/
      end
  end
end
