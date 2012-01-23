require 'spec_helper'

describe "User" do

  describe "wants to sign up" do
    it "and should see the sign up page" do
      visit root_path
      page.should have_css('a', :text => "Create an account")
      click_link "Create an account"
      page.should have_css('title', :title => 'Howling Vibes Archive | Sign up')
      page.should have_css('h3', :text => 'Create a new user account')
    end

    describe "submits an invalid form" do
      describe "with blank fields" do
        it "should redirect to signup page and show error messages" do
          visit '/users/new'
          click_button 'Sign up'
          page.should have_css('div.error')
          page.should have_content("can't be blank")
        end
      end
      describe "with a too long name" do
        it "should redirect to signup page and show error messages" do
          visit '/users/new'
          too_long_name = "a" * 31
          within(".new_user") do
            fill_in 'Name', :with => too_long_name
            fill_in 'Email', :with => "foobar@foobar.org"
            fill_in 'Password', :with => 'password'
            fill_in 'Password confirmation', :with => 'password'
          end
          click_button 'Sign up'
          page.should have_css('div.error')
          page.should have_content("Name is too long")
        end
      end

      describe "with a too short password" do
        it "should redirect to signup page and show error messages" do
          visit '/users/new'
          within(".new_user") do
            fill_in 'Name', :with => "John Doe"
            fill_in 'Email', :with => "foobar@foobar.org"
            fill_in 'Password', :with => 'pass'
            fill_in 'Password confirmation', :with => 'pass'
          end
          click_button 'Sign up'
          page.should have_css('div.error')
          page.should have_content("Password is too short")
        end
      end
      describe "with an invalid email adress" do
        it "should redirect to signup page and show error messages" do
          visit '/users/new'
          invalid_email = "rogeratgmail com"
          within(".new_user") do
            fill_in 'Name', :with => "John Doe"
            fill_in 'Email', :with => invalid_email
            fill_in 'Password', :with => 'password'
            fill_in 'Password confirmation', :with => 'password'
          end
          click_button 'Sign up'
          page.should have_css('div.error')
          page.should have_content("Email is invalid")
        end
      end
      describe "with an email adress already in the database" do
        before(:each) do
          User.create!(name: "Henry The First", email: "henry@dude.org",
                       password: "password", password_confirmation: "password")
        end
        it "should redirect to signup page and show error messages" do
          visit '/users/new'
          within(".new_user") do
            fill_in 'Name', :with => "John Doe"
            fill_in 'Email', :with => "henry@dude.org"
            fill_in 'Password', :with => 'password'
            fill_in 'Password confirmation', :with => 'password'
          end
          click_button 'Sign up'
          page.should have_css('div.error')
          page.should have_content("Email has already been taken")
        end
      end
    end

    describe "submits a valid form" do
      it "should create a user and redirect to root_page" do
        lambda do
          visit '/users/new'
          within(".new_user") do
            fill_in 'Name', :with => "John Doe"
            fill_in 'Email', :with => "henry@dude.org"
            fill_in 'Password', :with => 'password'
            fill_in 'Password confirmation', :with => 'password'
          end
          click_button 'Sign up'
          page.should have_css('div.success',
            :text => "You successfully created an account!")
        end.should change(User, :count).by(1)
      end
    end
  end

  describe "wants to log in" do

    it "should show a login form" do
      visit '/signin'
      page.should have_css('h3', :text => "Log in")
      page.should have_css('form.new_user_session')
    end

    describe "failure" do
      before(:each) do
        User.create!(:name => "John Doe", :email => "john@doe.org",
                     :password => "password",
                     :password_confirmation => "password")
      end

      it "should show why the login failed" do
        visit '/signin'
        within(".new_user_session") do
          fill_in 'Email', :with => "john@doe.org"
          fill_in 'Password', :with => "foobar"
        end
        click_button 'Log in'
        page.should have_css("div.error", :text => "Invalid email or password")
      end
    end
    describe "success" do
      before(:each) do
        @user = User.create!(:name => "John Doe",
                     :email => "john@doe.org",
                     :password => "password",
                     :password_confirmation => "password")
      end
      it "should welcome user" do
        visit '/signin'
        within(".new_user_session") do
          fill_in 'Email', :with => "john@doe.org"
          fill_in 'Password', :with => "password"
        end
        click_button 'Log in'
        page.should have_css('div.success',
            :text => "Hello John Doe, you successfully logged in!")
        page.should have_css('a', :text => 'Sign out')
      end
    end
  end

  describe "wants to sign out" do
    it "should log user out after clicking 'Sign out' link" do
      create_user
      integration_sign_in
      click_link 'Sign out'
      page.should have_css('div.notification',
                           :text => 'You successfully logged out.')
    end
  end

  describe "wants to update his profile information" do
    describe "visits the 'edit' page for his profile" do
      it "should not see a 'Edit Profile' link" do
        @user = create_user("foobar@foobar.com", "password")
        visit root_path
        page.should_not have_css('a', :text => "Edit profile")
      end
      it "should see the profile, make changes and submit it" do
        @user = create_user("foobar@foobar.com", "password")
        integration_sign_in("foobar@foobar.com", "password")
        click_link "Edit profile"
        page.should have_css('h3', :text => "Edit your profile")
        page.should have_css('form.edit_user')
        fill_in 'Name', :with => "Keef Richards"
        fill_in 'Email', :with => "foobar@foobar.org"
        fill_in 'Password', :with => 'password'
        fill_in 'Password confirmation', :with => 'password'
        click_button "Update your profile"
        page.should have_css('div.success',
              :text => "You successfully updated your profile!")
        page.should have_content('Hello, Keef Richards')
        page.should have_css('h3', :text => "ALL SESSIONS!")
      end
    end
  end
end
