class ChatmsgsController < ApplicationController
  before_action :check_admin

  def index
    @grid_chatmsgs=initialize_grid(Chatmsg)
  end

  def new
    @chatmsg=Chatmsg.new
  end

  def create
    @chatmsg=Chatmsg.new(chatmsg_params)
    @chatmsg.msgtype="1"
    if @chatmsg.save
      $redis.publish('static',@chatmsg.to_json);
      redirect_to chatmsgs_path
    else
      render :new
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_chatmsg
    @chatmsg = Chatmsg.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def chatmsg_params
    params.require(:chatmsg).permit(:title,:content,:topshow,:type)
  end

  def check_admin
    if !signed_in?
      flash[:alert] = "Please sign in to continue"
      redirect_to new_session_path
    else
      @user = current_user
      if !current_user.admin
        redirect_to user_path(current_user)
      end
    end
  end

end
