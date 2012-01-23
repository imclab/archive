# create a user 
def create_user(email = "johnny@foobar.com", password = "password")
  User.create!(:name => email.split('@')[0], :email => email,
               :password => password, :password_confirmation => password)
end

# Signs user in, for controller tests
def controller_sign_in(user)
  controller.sign_in(user)
end

# User visits the sign in page, signs in, session[:user_id] gets set
def integration_sign_in(email = "johnny@foobar.com", password = "password")
  visit '/signin'
  within(".new_user_session") do
    fill_in 'Email', :with => email
    fill_in 'Password', :with => password
  end
  click_button 'Log in'
end
