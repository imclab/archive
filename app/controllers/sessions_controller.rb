class SessionsController < ApplicationController
  before_filter :authorize,       only: [:new, :destroy]
  before_filter :authorize_admin, only: [:new, :create, :destroy]

  def index
    valid_options = ['by_session_date']
    if valid_options.include? params[:sort]
      @sessions = Session.send(params[:sort])
      @sessions.reverse! if params[:reverse]
    else
      @sessions = Session.by_session_date.reverse
    end

    @title = "All sessions"
  end

  def destroy
    Session.find(params[:id]).destroy
    flash_message :notification, "You successfully deleted a session"
    redirect_to sessions_path
  end
end
