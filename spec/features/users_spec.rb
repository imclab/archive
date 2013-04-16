require 'spec_helper'

describe 'a user' do
  describe 'wants to sign up' do
    describe 'submits an invalid form' do
      it 'should redirect to signup page and show him the errors he made' do
        visit root_path
        click_link 'Create an account'

        within('.new_user') do
          fill_in 'Name', with: 'John Doe'
          fill_in 'Email', with: 'foobar@foobar.org'
          fill_in 'Password', with: 'pass'
          fill_in 'Password confirmation', with: 'pass'
        end

        click_button 'Sign up'
        page.should have_css('div.error', text: 'Password is too short')
      end
    end

    describe 'submits a valid form' do
      it 'should create a user and redirect to root path' do
        visit root_path
        click_link 'Create an account'

        within('.new_user') do
          fill_in 'Name', with: 'John Doe'
          fill_in 'Email', with: 'henry@dude.org'
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
        end

        click_button 'Sign up'

        page.should have_css('div.success', text: 'You successfully created an account!')
      end
    end
  end

  describe 'wants to log in' do
    before do
      User.create!(
        name: 'John Doe',
        email: 'john@doe.org',
        password: 'password',
        password_confirmation: 'password'
      )
    end

    describe 'does not fill in correct data in log in form' do
      it 'should show why the login failed' do
        visit '/signin'

        within('.new_user_session') do
          fill_in 'Email', with: 'john@doe.org'
          fill_in 'Password', with: 'foobar'
        end

        click_button 'Log in'

        page.should have_css('div.error', text: 'Invalid email or password')
      end
    end

    describe 'fills in the correct data in log in form' do
      it 'should welcome user' do
        visit '/signin'

        within('.new_user_session') do
          fill_in 'Email', with: 'john@doe.org'
          fill_in 'Password', with: 'password'
        end

        click_button 'Log in'

        page.should have_content('Sign out')
      end
    end
  end

  describe 'wants to sign out' do
    it 'should log user out after clicking Sign out link' do
      create_user
      integration_sign_in

      click_link 'Sign out'

      page.should have_css('div.notification', text: 'You successfully logged out.')
    end
  end

  describe 'wants to update his profile information' do
    describe 'visits the edit page for his profile' do
      it 'should see the profile, make changes and submit it' do
        create_user('foobar@foobar.com', 'password')

        integration_sign_in('foobar@foobar.com', 'password')

        click_link 'Edit profile'

        fill_in 'Name', with: 'Keef Richards'
        fill_in 'Email', with: 'foobar@foobar.org'
        fill_in 'Password', with: 'password'
        fill_in 'Password confirmation', with: 'password'

        click_button 'Update your profile'

        page.should have_css('div.success', text: 'You successfully updated your profile!')
        page.should have_content('Hello, Keef Richards')
        page.should have_css('h3', text: 'All Sessions')
      end
    end
  end
end
