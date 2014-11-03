class CommentsController < ApplicationController
  def new
  end

  def create
    @micropost=Micropost.find(params[:comment][:mid])
    @comment = @micropost.comments.build(comment_params)
    @comment.user=current_user
    if @comment.save
      flash[:success] = "comment created!"
      if current_user!=@micropost.user
        @unread=Unreadrelation.find_by(unreaduser_id:@micropost.user.id,unreadmicropost_id:@micropost.id)
        if(@unread.nil?)
          @unread=Unreadrelation.create(unreaduser_id:@micropost.user.id,unreadmicropost_id:@micropost.id,unread:0)
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

  private
  def comment_params
    params.require(:comment).permit(:msg)
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
