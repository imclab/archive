class ApplicationController < ActionController::Base
  protect_from_forgery
  after_filter :save_last_activity

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

  helper_method :current_user
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_user?(user)
    user == current_user
  end

  def deny_access
    flash_message :notification, "Please sign in"
    redirect_to signin_path
  end

  helper_method :comments_since_last_activity
  def comments_since_last_activity
    if cookies[:last_activity]
      @comments_since_last_activity ||= Comment.where('created_at > ?', cookies[:last_activity])
    end
    @comments_since_last_activity || []
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

    def save_last_activity
      cookies.permanent[:last_activity] = Time.now.utc if current_user && request.get?
    end
end
