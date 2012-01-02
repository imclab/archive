class ApplicationController < ActionController::Base
  protect_from_forgery

  def flash_message(type, text)
    flash[type] ||= []
    flash[type] << text
  end
end
