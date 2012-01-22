class UsersController < ApplicationController

  def new 
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash_message :success, "You successfully created an account!" 
      redirect_to sessions_path
    else
      render "new"
    end
  end
end
