class SessionsController < ApplicationController
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
end
