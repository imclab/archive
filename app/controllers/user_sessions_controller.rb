class UserSessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:user_session][:email])
    if user && user.authenticate(params[:user_session][:password])
      sign_in user 
      flash_message :success, "Hello #{user.name}, you successfully logged in!"
      redirect_to sessions_path 
    else
      flash_message :error, "Invalid email or password"
      render "new"
    end
  end

  def destroy
    sign_out
    flash_message :notification, "You successfully logged out."
    redirect_to sessions_path
  end
end
