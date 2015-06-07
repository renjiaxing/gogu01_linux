class PmsgsController < ApplicationController
  before_action :set_pmsg, only: [:show, :edit, :update, :destroy]

  def index
    @msgs=Pmsg.where("fromuser_id=? or touser_id=?", current_user.id, current_user.id).order(created_at: :desc)
  end

  def new
    @pmsg=Pmsg.new
    if !params[:mid].nil?
      @touser=Micropost.find(params[:mid]).user
    elsif !params[:uid].nil?
      @touser=User.find(params[:uid])
    end
  end

  def create
    @pmsg=Pmsg.new(pmsg_params)
    p1=Pmsg.where("fromuser_id=? and touser_id=?", params[:pmsg][:fromuser_id], params[:pmsg][:touser_id])
    p2=Pmsg.where("fromuser_id=? and touser_id=?", params[:pmsg][:touser_id], params[:pmsg][:fromuser_id])
    if !p1.empty?
      anonnum=p1[0].anonnum
      anontonum=p1[0].anontonum
    elsif !p2.empty?
      anonnum=p2[0].anontonum
      anontonum=p2[0].anonnum
    elsif p1.empty? and p2.empty?
      to_user=User.find(params[:pmsg][:touser_id])
      if current_user!=to_user
        anonnum=current_user.anonnum
        current_user.update_column(:anonnum, anonnum+1)
        anontonum=to_user.anonnum
        to_user.update_column(:anonnum, anontonum+1)
      else
        anontonum=anonnum=0
      end
    end
    @pmsg.anonnum=anonnum
    @pmsg.anontonum=anontonum
    if @pmsg.save
      unreadmsg=Unreadmsg.where("msgfrom_id=? and msgto_id=?", params[:pmsg][:touser_id], params[:pmsg][:fromuser_id])
      if unreadmsg.empty?
        unreadmsg=Unreadmsg.create(msgfrom_id: params[:pmsg][:touser_id], msgto_id: params[:pmsg][:fromuser_id])
      else
        unreadmsg=unreadmsg[0]
      end
      if params[:pmsg][:fromuser_id]!=params[:pmsg][:touser_id]
        unreadmsg.msgunread+=1
      end
      if unreadmsg.save
        @msg={}
        @msg["msgtype"]="3"
        @msg["user_id"]=params[:pmsg][:touser_id]
        @msg["title"]="你有新的私信～"
        @msg["content"]="你有新的私信～"
        @msg["topshow"]="你有新的私信～"
        $redis.publish('static', @msg.to_json);
        redirect_to pmsgs_path

        content={}
        content_alert={}
        content_alert["alert"]="你有新的私信～"
        content["aps"]=content_alert

        req_params={}
        req_params.merge!({message: content.to_json,
                           message_type: 1,
                           account: "account"+params[:pmsg][:touser_id].to_s})
        begin
          push_single_account(req_params)
        rescue Exception => e
          # push_single_account("1",0,content)
        end
      else
        redirect_to :new
      end
    else
      redirect_to :new
    end

  end


  private

  def set_pmsg
    @pmsg = Pmsg.find(params[:id])
  end

  def pmsg_params
    params.require(:pmsg).permit(:fromuser_id, :touser_id, :msg, :anonnum)
  end

end
