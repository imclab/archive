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

  before(:each) do
    @attr = { :session_date => Time.now.to_date }
  end

  it "should create a new instance given valid session_date" do
    Session.create!(@attr)
  end

  it "should require a session_date" do
    no_date_session = Session.new(@attr.merge(:session_date => nil))
    no_date_session.should_not be_valid
  end

  it "should only be valid with a date as session_date" do
    wrong_date_session = Session.new(:session_date => "String")
    wrong_date_session.should_not be_valid
  end

  describe "Song associations" do
    before(:each) do
      @session = Session.create(:session_date => Time.now.to_date)
    end

    it "should have a songs attribute" do
      @session.should respond_to(:songs)
    end

    it "should validate :songs" do
      @session.songs.build(:file_name => "dude.bmp")
      @session.should_not be_valid
    end
    
    it "should show songs in the right order" do
      song1 = @session.songs.create!(:file_name => "03.testing.mp3")
      song2 = @session.songs.create!(:file_name => "01.testing.mp3")
      @session.reload
      
      @session.songs.should == [song2, song1]
    end
  end
end
