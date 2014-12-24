class UsersController < ApplicationController

  before_action :check_signed_in, except: [:new, :create, :account_confirmation, :root_page,:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
#      @user.send_confirmation
      @user.update_column(:email_confirmed, true)
      redirect_to new_session_path, notice: "User Registered successfully"
    else
#      redirect_to new_user_path
      render 'new'
    end
  end

  def show
    user=User.find_by_admin(true)
    if !user.nil?
      @top_micropost=user.microposts.order(created_at: :desc).limit(1)[0]
    end
    @microposts=Micropost.where(visible: true).order(created_at:  :desc).page(params[:page]).per(6)
    if (!params[:micropost_id].nil?)
      @micropost=Micropost.find(params[:micropost_id])
    end
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
    if (@user)
      @user.update_column(:email_confirmed, true)
      @user.update_column(:password_reset_token, nil)
      redirect_to new_session_url, :notice => "Account confirmed"
    else
      redirect_to new_session_url, :notice => "Account could not be confirmed"
    end
  end

  def root_page

  end

  def my_msg
    @microposts=Micropost.where("user_id=? AND visible=?", current_user.id, true).order(updated_at: :desc).page(params[:page]).per(6)
  end

  def unread_msg
    @microposts=current_user.unreadmicroposts.where("unread!=0 AND visible=true").order(updated_at: :desc).page(params[:page]).per(6)
  end

  def pre_update_passwd
    @user=current_user
  end

  def update_passwd
    @user=current_user
    if @user.update_attributes(user_params)
      redirect_to user_path(current_user), notice: "密码更新成功"
    else
      render "pre_update_passwd"
    end
  end

  def pre_update_inform
    @user=current_user
  end

  def update_inform
    @user=current_user
    if @user.update_attributes(user_params)
      redirect_to user_path(current_user), notice: "信息修改成功"
    else
      render "pre_update_inform"
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :phone, :password, :password_confirmation)
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
