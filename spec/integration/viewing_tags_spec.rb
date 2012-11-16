require 'spec_helper'

describe 'viewing all tags' do
  before(:each) do
    song = Song.create!(file_name: '01.testing.mp3')
    song.tags.create!(name: 'supertest')
    song.tags.create!(name: 'greattest')
  end

  it 'allows me to see all tags and the songs they are associated with' do
    visit tags_path

    page.should have_css('span.tag', text: 'supertest')
    page.should have_css('span.tag', text: 'greattest')

    click_link 'supertest'

    page.should have_content('01.testing.mp3')
  end
end
