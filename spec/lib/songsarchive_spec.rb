require File.expand_path('../../../app/lib/songs_archive', __FILE__)

describe SongsArchive::Directory do
  let(:fixtures) do
    File.expand_path('../../fixtures/archive', __FILE__)
  end

  let(:archive) do
    SongsArchive::Directory.new(fixtures)
  end

  it "should return a list of sessions" do
    archive.sessions.should include('2011.07.01', '2011.07.07', '2011.08.02')
  end

  it "should return a list of sessions, and only sessions" do
    archive.sessions.should_not include('Brezel', 'Superman', 'Sanchez')
  end

  it "should return a list of files for a session" do
    archive.files_in_session('2011.07.21').should include('02.you_too.mp3')
  end

  it "should only return audio files as session files" do
    archive.files_in_session('2011.07.21').should_not include('README.md', 'lolzomat')
  end
end
