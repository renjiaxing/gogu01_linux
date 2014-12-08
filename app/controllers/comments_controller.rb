class CommentsController < ApplicationController
  before_action :set_comment, only: [:update,:edit,:delete_flag]

  def new
  end

  def create
    @micropost=Micropost.find(params[:comment][:mid])
    @comment = @micropost.comments.build(comment_params)
    @comment.user=current_user
    if @comment.save
      flash[:success] = "comment created!"
      anon=@micropost.anons.find_by_anonuser_id(current_user.id)
      if(anon.nil?)
        @micropost.anonusers.push(current_user)
        anon=@micropost.anons.find_by_anonuser_id(current_user)
        anon.anonnum=@micropost.anonnum
        if anon.save
          @micropost.anonnum=@micropost.anonnum+1
          @micropost.save
        end
      end
      if current_user!=@micropost.user
        @unread=Unreadrelation.find_by(unreaduser_id: @micropost.user.id, unreadmicropost_id: @micropost.id)
        if (@unread.nil?)
          @unread=Unreadrelation.create(unreaduser_id: @micropost.user.id, unreadmicropost_id: @micropost.id, unread: 0)
        end
        @unread.unread+=1
        @unread.save
      end
      @comments=@micropost.comments.order(:update_at)
      redirect_to details_micropost_path(@micropost)
    else
      flash[:alert] = "comment failed!"
      @comments=@micropost.comments.order(:update_at)
      render details_micropost_path(@micropost)
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html {  redirect_to details_micropost_path(@micropost), notice: 'Comment was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def delete_flag
    @comment.visible=false;
    if @comment.save
      flash[:success] = "comment delete created!"
    else
      flash[:alert] = "comment delete failed!"
    end
    redirect_to details_micropost_path(@micropost)
  end

  private
  def comment_params
    params.require(:comment).permit(:msg)
  end

  def set_comment
    @comment = Comment.find(params[:id])
    @micropost=@comment.micropost
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
