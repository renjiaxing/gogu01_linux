class UsersController < ApplicationController

  before_action :check_signed_in, except: [:new, :create, :account_confirmation,:root_page]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save!
#      @user.send_confirmation
      @user.update_column(:email_confirmed, true)
      redirect_to user_path(current_user), notice: "User Registered successfully"
    else
      render 'new'
    end
  end

  def show
    @microposts=Micropost.order(updated_at: :desc).page(params[:page]).per(6)
    respond_to do |format|
      format.html
      format.js # add this line for your js template
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      redirect_to user_path(current_user), notice: "User updated successfully"
    else
      render 'edit'
    end
  end

  def account_confirmation
    @user = User.find_by_password_reset_token(params[:token])
    if(@user)
      @user.update_column(:email_confirmed, true)
      @user.update_column(:password_reset_token, nil)
      redirect_to new_session_url, :notice => "Account confirmed"
    else
      redirect_to new_session_url, :notice => "Account could not be confirmed"
    end
  end

  def root_page

  end

  private
  def user_params
    params.require(:user).permit(:name,:email,:phone,:password,:password_confirmation)
  end

  def check_signed_in
    if !signed_in?
      flash[:alert] = "Please sign in to continue"
      redirect_to new_session_path
    else
      @user = current_user
    end
  end
end
