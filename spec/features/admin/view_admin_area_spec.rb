require 'spec_helper'

describe 'viewing admin dashboard' do
  before(:each) do
    user = create_user('admin@gmail.com', 'password')
    user.toggle!(:admin)
  end

  it 'allows me to log in and go to the admin dashboard' do
    visit sessions_path
    click_link 'Sign in'

    within '.new_user_session' do
      fill_in 'Email', with: 'admin@gmail.com'
      fill_in 'Password', with: 'password'
    end

    click_button 'Log in'

    page.should have_content('Admin Dashboard')

    click_link 'Admin Dashboard'

    page.should have_content('Sessions')
  end
end
