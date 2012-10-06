require 'spec_helper'

describe "Tags" do
  describe "listing all tags" do
    before(:each) do
      song1 = Song.create!(file_name: '01.testing.mp3')
      song2 = Song.create!(file_name: '02.testing.mp3')
      song1.tags.create!(name: 'supertest')
      song2.tags.create!(name: 'greattest')
    end

    it "should have an element for each tag" do
      visit '/tags'

      page.should have_css('span.tag', text: 'supertest')
      page.should have_css('span.tag', text: 'greattest')
    end
  end
end
