class SessionsController < ApplicationController

  before_action :check_signed_in, except: :destroy

  def new
  end

  def create
    user = User.authenticate_user(params[:email], params[:password])

    if user
      sign_in user if params[:remember_me]
      session_create user.id
      redirect_to root_url
    else
      flash.now.alert = "Invalid Email or Password"
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
      redirect_to root_url
    end
  end

end
