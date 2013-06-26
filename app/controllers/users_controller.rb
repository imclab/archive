class UsersController < ApplicationController
  before_filter :authorize,    only: [:edit, :update]
  before_filter :correct_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
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

    if user.update_attributes(user_params)
      flash_message :success, 'You successfully updated your profile!'
      redirect_to sessions_path
    else
      render 'edit'
    end
  end

  private

    def correct_user
      user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(user)
    end

    def user_params
      params.require(:user).permit(:email, :name, :password, :password_confirmation)
    end
end
