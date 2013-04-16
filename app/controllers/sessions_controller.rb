class SessionsController < ApplicationController
  SORT_OPTIONS = ['by_session_date']
  def index
    if SORT_OPTIONS.include? params[:sort]
      @sessions = Session.send(params[:sort])
      @sessions.reverse! if params[:reverse]
    else
      @sessions = Session.by_session_date.reverse
    end

    @title = "All sessions"
  end
end
