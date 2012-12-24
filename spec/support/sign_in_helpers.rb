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

def admin_integration_sign_in(email = 'johnny@foobar.com', password = 'password')
  integration_sign_in(email, password)
  click_link 'Admin Dashboard'
end
