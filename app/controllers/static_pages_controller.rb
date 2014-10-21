# encoding: utf-8
class StaticPagesController < ApplicationController
  before_action :signed_in_user

  def index
  end

  private
  def signed_in_user
     redirect_to new_session_path ,notice:"请登录" unless signed_in?
  end
end
