class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  before_action :check_unread

  def check_unread
    if current_user.nil?
      @unread=false
    else
      unread=current_user.unreadmicroposts.where("unread>?", 0)
      if unread.size>0
        @unread=true
      else
        @unread=false
      end
    end
  end

end
