class UsersController < ApplicationController

  before_action :check_signed_in, except: [:new, :create, :account_confirmation, :root_page,:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.randint=rand(100)
    # if params[:code]!=Userconfig.find_by_name("code").value
    #   flash[:alert]="邀请码错误～"
    #   render 'new'
    # elsif @user.save
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
      @top_micropost=user.microposts.where(visible:true).order(created_at: :desc).limit(1)[0]
    end
    @microposts=Micropost.where(visible: true).order(created_at:  :desc).page(params[:page]).per(8)
    if (!params[:micropost_id].nil?)
      @micropost=Micropost.find(params[:micropost_id])
    end

    @new_microposts=Micropost.where(visible: true).order("created_at desc").limit(6)

    @item="show"

    # fresh_when(etag:[@top_micropost,@microposts])
    # respond_to do |format|
    #   format.html
    #   format.js # add this line for your js template
    # end
  end

  def myshow
    user=User.find_by_admin(true)
    user_stocks=[]
    current_user.mystocks.each do |t|
      user_stocks<<t.stock
    end
    if !user.nil?
      @top_micropost=user.microposts.where(visible:true).order(created_at: :desc).limit(1)[0]
    end
    @microposts=Micropost.where(stock:user_stocks,visible: true).order(created_at:  :desc).page(params[:page]).per(8)
    if (!params[:micropost_id].nil?)
      @micropost=Micropost.find(params[:micropost_id])
    end

    @new_microposts=Micropost.where(visible: true).order("created_at desc").limit(6)

    @item="myshow"

    render 'show'

    # fresh_when(etag:[@top_micropost,@microposts])
  end

  def stockinfo
    @microposts=Micropost.where(microtype:1,visible: true).order(created_at: :desc).page(params[:page]).per(8)
    @new_microposts=Micropost.where(visible: true).order("created_at desc").limit(6)
    @item="stockinfo"
    render 'show'
  end

  def stocknoinfo
    @microposts=Micropost.where(microtype:0,visible: true).order(created_at: :desc).page(params[:page]).per(8)
    @new_microposts=Micropost.where(visible: true).order("created_at desc").limit(6)
    @item="stocknoinfo"
    render 'show'
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

  def my_info

  end

  def my_reply
    @microposts=Micropost.joins(:replyrelationships).
        where("microposts.visible=? and replyrelationships.replyuser_id=?",
              true, current_user.id).order("microposts.created_at desc").page(params[:page]).per(6)
    @new_microposts=Micropost.where(visible: true).order("created_at desc").limit(6)
  end

  def my_msg
    @microposts=Micropost.where("user_id=? AND visible=?", current_user.id, true).order(updated_at: :desc).page(params[:page]).per(6)
    @new_microposts=Micropost.where(visible: true).order("created_at desc").limit(6)
    # fresh_when(etag:[@microposts])
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
    user=current_user
    if @user.update_attribute(:name, params[:user][:name]) && @user.update_attribute(:phone, params[:user][:phone])
      redirect_to user_path(current_user), notice: "信息修改成功"
    else
      render "pre_update_inform"
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :phone, :password, :password_confirmation,:randint)
  end

  def user_nopasswd_params
    params.require(:user).permit(:name, :email, :phone)
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
