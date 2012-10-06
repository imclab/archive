require 'spec_helper'

describe "Tags" do
  describe "GET 'index'" do
    it "should have the right title" do
      visit '/tags'
      current_path.should == tags_path
      page.should have_css('title', :text => 'Howling Vibes Archive | All tags')
    end

    it "should have an element for each tag" do
      song1 = Song.create!(file_name: "01.testing.mp3")
      song2 = Song.create!(file_name: "02.testing.mp3")
      song1.add_tag("supertest")
      song2.add_tag("greattest")
      visit '/tags'
      page.should have_css('span.tag', :text => 'supertest')
      page.should have_css('span.tag', :text => 'greattest')
    end
  end
end
