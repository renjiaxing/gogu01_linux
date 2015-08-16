class PmsgsController < ApplicationController
  before_action :set_pmsg, only: [:show, :edit, :update, :destroy]

  def index

    p1=Pmsg.where("fromuser_id=?", current_user.id)
    p2=Pmsg.where("touser_id=?", current_user.id)
    u=current_user

    tmp1=[]
    p1.each do |p|
      t={}
      t["touser"]=p.touser_id
      t["anon"]=p.anonnum
      tmp1<<t
    end

    tmp2=[]
    p2.each do |p|
      t={}
      t["touser"]=p.fromuser_id
      t["anon"]=p.anontonum
      tmp2<<t
    end
    @msginfo=tmp1|tmp2

    # tmp_unread=[]
    tmp_read=[]

    @msginfo.each do |t|
      unread=Unreadmsg.where("msgfrom_id=? and msgto_id=?", current_user.id, t["touser"]).first
      tmp=Pmsg.where("(fromuser_id=? and touser_id=?) or (touser_id=? and fromuser_id=?)",
                     t["touser"], current_user.id, t["touser"], current_user.id).order("created_at desc")[0]
      # tmp.touser_id=t["touser"]
      if !unread.nil?
        tmp_read<<tmp
      else
        tmp=Pmsg.where("(fromuser_id=? and touser_id=?) or (touser_id=? and fromuser_id=?)", t["touser"], current_user.id, t["touser"], current_user.id)[0]
        # tmp.touser_id=t["touser"]
        tmp_read<<tmp
      end

    end
    @pmsgs=tmp_read.sort_by { |t| t.created_at }.reverse

    @new_microposts=Micropost.where(visible: true).order("created_at desc").limit(6)
    # fresh_when(etag:[@msgs])
  end

  def new
    @pmsg=Pmsg.new
    @new_microposts=Micropost.where(visible: true).order("created_at desc").limit(6)

    if !params[:mid].nil?
      @touser=Micropost.find(params[:mid]).user
      @pmsgs=Pmsg.where("(fromuser_id=? AND touser_id=?) OR (fromuser_id=? AND touser_id=?)",
                        current_user, Micropost.find(params[:mid]).user_id,
                        Micropost.find(params[:mid]).user_id, current_user).order("created_at")
      unreadmsg=Unreadmsg.where("(msgfrom_id=? and msgto_id=?) OR (msgto_id=? and msgfrom_id=?)",
                                current_user, Micropost.find(params[:mid]).user_id,
                                Micropost.find(params[:mid]).user_id, current_user)
    elsif !params[:uid].nil?
      @touser=User.find(params[:uid])
      @pmsgs=Pmsg.where("(fromuser_id=? AND touser_id=?) OR (fromuser_id=? AND touser_id=?)",
                        current_user, params[:uid],
                        params[:uid], current_user).order("created_at")
      unreadmsg=Unreadmsg.where("(msgfrom_id=? and msgto_id=?) OR (msgto_id=? and msgfrom_id=?)",
                                current_user, params[:uid],
                                params[:uid], current_user)
    end

    unreadmsg.each do |m|
      m.msgunread=0
      m.save
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
        # $redis.publish('static', @msg.to_json);

        touser=User.find(params[:pmsg][:touser_id])

        if touser.android_chat_push
          current_user.umeng_android_push_send("你有新的私信~", "你有新的私信~", "你有新的私信~", "customizedcast", "gogu02", params[:pmsg][:touser_id].to_s, "go_activity", "com.rjx.gogu02.aty.MyChatAty", {})
        end

        if touser.apple_chat_push
          content={}
          content_alert={}
          content_alert["alert"]="你有新的私信～"
          content["aps"]=content_alert
          content["controller"]="chat"

          req_params={}
          req_params.merge!({message: content.to_json,
                             message_type: 1,
                             account: "account"+params[:pmsg][:touser_id].to_s})
          begin
            push_single_account(req_params)
          rescue Exception => e
            # push_single_account("1",0,content)
          end
        end

        redirect_to action: 'new', uid: params[:pmsg][:touser_id]
      else
        redirect_to action: 'new', uid: params[:pmsg][:touser_id]
      end
    else
      redirect_to action: 'new', uid: params[:pmsg][:touser_id]
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
