class CommentsController < ApplicationController
  def new
  end

  def create
    @micropost=Micropost.find(params[:comment][:mid])
    @comment = @micropost.comments.build(comment_params)
    if @comment.save
      flash[:success] = "comment created!"
      @comments=@micropost.comments
      redirect_to details_micropost_path(@micropost)
    else
      flash[:alert] = "comment failed!"
      @comments=@micropost.comments
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
