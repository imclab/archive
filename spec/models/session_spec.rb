# == Schema Information
#
# Table name: sessions
#
#  id           :integer         not null, primary key
#  session_date :date
#  created_at   :datetime
#  updated_at   :datetime
#

require 'spec_helper'

describe Session do

  it "should create a new instance given valid session_date" do
    Session.create!(session_date: Date.today)
  end

  it "should require a session_date" do
    Session.new(session_date: nil).should_not be_valid
  end

  it "should only be valid with a date as session_date" do
    Session.new(:session_date => "String").should_not be_valid
  end

  it "should have a by_session_date method" do
    Session.should respond_to(:by_session_date) 
  end

  describe "Song associations" do
    before(:each) do
      @session = Session.create!(session_date: Date.today) 
    end

    it "should have a songs attribute" do
      @session.should respond_to(:songs)
    end

    it "should validate :songs" do
      @session.songs.build(file_name: "dude.bmp")
      @session.should_not be_valid
    end
    
    it "should show songs in the right order" do
      song1 = @session.songs.create!(file_name: "03.testing.mp3")
      song2 = @session.songs.create!(file_name: "01.testing.mp3")
      @session.reload
      
      @session.songs.should == [song2, song1]
    end
  end
end
