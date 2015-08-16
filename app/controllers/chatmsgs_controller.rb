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
    # @chatmsg.msgtype="1"
    aty="com.rjx.gogu02.aty.MainActivity"
    extra={}
    if @chatmsg.save

      if @chatmsg.msgtype=="1"
        # $redis.publish('static',@chatmsg.to_json);
        if params[:chatmsg][:atyresource_id].nil?||params[:chatmsg][:atyresource_id]==""
          aty="com.rjx.gogu02.aty.MainActivity"
        else
          aty=Atyresource.find(params[:chatmsg][:atyresource_id]).aty
          if params[:chatmsg][:param1]&&params[:chatmsg][:atyresource_id]=="2"
            extra["id"]=params[:chatmsg][:param1]
          end
        end
        current_user.umeng_android_push_send(params[:chatmsg][:topshow],
                                             params[:chatmsg][:title], params[:chatmsg][:content], "broadcast", "",
                                             "", "go_activity", aty, extra)
        redirect_to chatmsgs_path
      elsif @chatmsg.msgtype=="2"
        content={}
        content_alert={}
        content_alert["alert"]=params[:chatmsg][:topshow]
        content["aps"]=content_alert

        if params[:chatmsg][:param1]&&params[:chatmsg][:atyresource_id]=="2"
          content["controller"]="vote"
          content["id"]=params[:chatmsg][:param1]
        end

        req_params={}
        req_params.merge!({message: content.to_json,
                           message_type: 1})

        push_all_devices(req_params)

        redirect_to chatmsgs_path
      end
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
    params.require(:chatmsg).permit(:title, :content, :topshow, :type, :atyresource_id, :param1, :msgtype)
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
