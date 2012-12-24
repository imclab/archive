require 'spec_helper'

describe 'Managing users' do
  before(:each) do
    admin = create_user
    admin.toggle!(:admin)
    admin_integration_sign_in

    create_user('john@example.com')
  end

  it 'allows me to see a list of all users' do
    click_link 'Users'

    page.should have_content('john@example.com')
  end

  it 'allows me to delete a user' do
    click_link 'Users'

    page.should have_content('john@example.com')
    click_link 'Delete this user'
    page.should_not have_content('john@example.com')
  end
end
