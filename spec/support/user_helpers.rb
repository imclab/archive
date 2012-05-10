# create a user
def create_user(email = "johnny@foobar.com", password = "password")
  User.create!(:name => email.split('@')[0], :email => email,
               :password => password, :password_confirmation => password)
end
