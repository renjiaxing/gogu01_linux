# encoding: utf-8
class StaticPagesController < ApplicationController
  # before_action :signed_in_user

  def index
    @tmp=''
    if (!params[:pmsg].nil?)
      if (!params[:pmsg][:msg].nil?)
        @tmp=params[:pmsg][:msg].to_s
      end
    end
    # $redis.publish('static',@tmp.to_s);
  end

  private
  def signed_in_user
    redirect_to new_session_path, notice: "请登录" unless signed_in?
  end
end
