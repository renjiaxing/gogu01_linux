class MicropostsController < ApplicationController
  before_action :check_signed_in, except: [:details]
  before_action :find_micropost, only: [:details, :add_good, :cancel_good, :edit, :update, :delete_flag]

  def new
    @micropost=current_user.microposts.build
  end

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.randint=rand(100)
    if params[:micropost][:stock_id].nil?|| params[:micropost][:stock_id]==""
      flash.now.notice = "请从下拉框中选择正确的股票代码"
      render 'new'
    elsif @micropost.save
      redirect_to user_path(current_user)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @micropost.update(micropost_params)
        format.html { redirect_to user_path, notice: 'Mciropost was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def delete_flag
    @micropost.visible=false;
    if @micropost.save
      flash[:success] = "micropost delete created!"
    else
      flash[:alert] = "micropost delete failed!"
    end
    redirect_to user_path
  end

  def details
    @comments=@micropost.comments.where(visible: true).order(:updated_at)
    if !current_user.nil?
      @unreadmicropost=current_user.unreadrelations.find_by_unreadmicropost_id(@micropost.id)
      if !@unreadmicropost.nil?
        @unreadmicropost.unread=0
        @unreadmicropost.save
      end
      unreply=Replyrelationship.where("replyuser_id=? and replymicropost_id=?", current_user.id,@micropost.id)
      if !unreply.empty?
        unreply[0].replyunread=0
        unreply[0].save
      end
    end
  end

  def add_good
    current_user.begoods<<@micropost
    redirect_to action: "show", controller: 'users', id: current_user.id, micropost_id: @micropost.id
  end

  def cancel_good
    current_user.begoods.delete(@micropost)
    redirect_to action: "show", controller: "users", id: current_user.id, micropost_id: @micropost.id
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :stock_id, :image,:randint)
  end

  def find_micropost
    @micropost=Micropost.find(params[:id])
  end

  def check_signed_in
    if !signed_in?
      flash[:alert] = "Please sign in to continue"
      redirect_to user_path(current_user)
    else
      @user = current_user
    end
  end

end
