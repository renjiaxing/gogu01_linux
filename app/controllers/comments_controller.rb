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
      Comment.save_comment(@micropost,current_user,@comment)
      # anon=@micropost.anons.find_by_anonuser_id(current_user.id)
      # if(anon.nil?)
      #   @micropost.anonusers.push(current_user)
      #   anon=@micropost.anons.find_by_anonuser_id(current_user)
      #   anon.anonnum=@micropost.anonnum
      #   if anon.save
      #     @micropost.anonnum=@micropost.anonnum+1
      #     @micropost.save
      #   end
      # end
      # @comment.anonid=@micropost.anons.find_by_anonuser_id(@comment.user.id).anonnum.to_s
      # @comment.save
      # if current_user!=@micropost.user
      #   @unread=Unreadrelation.find_by(unreaduser_id: @micropost.user.id, unreadmicropost_id: @micropost.id)
      #   if (@unread.nil?)
      #     @unread=Unreadrelation.create(unreaduser_id: @micropost.user.id, unreadmicropost_id: @micropost.id, unread: 0)
      #   end
      #   @unread.unread+=1
      #   @unread.save
      # end
      #
      # reply=Replyrelationship.find_by(replyuser_id:current_user.id,replymicropost_id:@micropost.id)
      # if reply.nil?
      #   reply=Replyrelationship.create(replyuser_id:current_user.id,replymicropost_id:@micropost.id,replyunread:0)
      # end
      # otherreplies=Replyrelationship.where(replymicropost_id: @micropost.id)
      #
      # @msg={}
      #
      #
      # otherreplies.each do |r|
      #   r.replyunread+=1
      #   r.save
      #   @msg["title"]="你回复的帖子有新的回复～"
      #   @msg["content"]="你回复的帖子有新的回复～"
      #   @msg["topshow"]="你回复的帖子有新的回复～"
      #   @msg["msgtype"]="4"
      #   @msg["user_id"]=r.replyuser_id
      #   $redis.publish('static',@msg.to_json)
      # end
      # @comments=@micropost.comments.order(:update_at)
      #
      # @msg["msgtype"]="2"
      # @msg["title"]="你有新的回复～"
      # @msg["content"]="你有新的回复～"
      # @msg["topshow"]="你有新的回复～"
      # @msg["user_id"]=@micropost.user_id
      # $redis.publish('static',@msg.to_json);

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
