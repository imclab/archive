class UsersController < ApplicationController
  before_filter :authorize,       only: [:edit, :update, :index, :destroy]
  before_filter :correct_user,    only: [:edit, :update]
  before_filter :authorize_admin, only: [:destroy, :index]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash_message :success, 'You successfully created an account!'
      redirect_to sessions_path
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])

    if user.update_attributes(params[:user])
      flash_message :success, 'You successfully updated your profile!'
      redirect_to sessions_path
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash_message :notification, 'User successfully deleted.'
    redirect_to sessions_path
  end

  private

    def correct_user
      user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(user)
    end
end
