class Admin::UsersController < Admin::BaseController
  def index
    @users = User.all
  end

  def destroy
    User.find(params[:id]).destroy
    flash_message :notification, 'User successfully deleted.'
    redirect_to admin_users_path
  end
end
