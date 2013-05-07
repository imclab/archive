require 'spec_helper'

describe Session do
  it 'should not be valid with a wrong session_date' do
    Session.new(session_date: 'foobar').should_not be_valid
  end

  describe '.by_session_date' do
    it 'orders session by session_date' do
      session_one = Session.create!(session_date: 2.days.ago)
      session_two = Session.create!(session_date: Date.today)

      Session.by_session_date.should == [session_one, session_two]
    end
  end

  describe 'song associations' do
    let(:session) do
      Session.create!(session_date: Date.today)
    end

    it 'should validate :songs' do
      session.songs.build(file_name: "dude.bmp")
      session.should_not be_valid
    end

    it 'should show songs in the right order' do
      song1 = session.songs.create!(file_name: "03.testing.mp3")
      song2 = session.songs.create!(file_name: "01.testing.mp3")

      session.reload

      session.songs.should == [song2, song1]
    end
  end
end
