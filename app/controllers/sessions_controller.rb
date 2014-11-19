class SessionsController < ApplicationController

  before_action :check_signed_in, except: :destroy

  def new
  end

  def create
    user = User.authenticate_user(params[:email], params[:password])

    if user
      sign_in user if params[:remember_me]
      session_create user.id
      redirect_to user_path(current_user)
    else
      flash.now.alert = "用户名或者密码错误！"
      render 'new'
    end
  end

  def destroy
    sign_out
    session_destroy
    redirect_to root_url, notice: "Signed out successfully"
  end

  private
  def check_signed_in
    if signed_in?
      flash.now.alert = "Already signed in"
      redirect_to user_path(current_user)
    end
  end

end
