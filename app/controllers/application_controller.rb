class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :signed_in?

  def flash_message(type, text)
    flash[type] ||= []
    flash[type] << text
  end

  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out
    session[:user_id] = nil
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_user?(user)
    user == current_user
  end

  def signed_in?
    current_user != nil
  end

  def deny_access
    flash_message :notification, "Please sign in"
    redirect_to signin_path
  end

  protected

    def authorize
      deny_access unless User.find_by_id(session[:user_id])
    end

    def authorize_admin
      unless current_user && current_user.admin
        flash_message :notification, "Sorry, you are not allowed to do this"
        redirect_to sessions_path
      end
    end
end
