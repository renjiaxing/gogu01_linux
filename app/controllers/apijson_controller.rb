class ApijsonController < ApplicationController
  before_action :checktoken, except: [:login_json, :login_token_json, :reg_json, :get_version_json, :api_add_chat]

  def get_version_json
    tmp={}
    tmp["version"]=2
    render json: tmp
  end

  def microposts_json

    if !params[:my_reply_id].nil?
      tmp_c=Comment.where("user_id=?", params[:my_reply_id]).select("micropost_id").distinct
      c_arr=[]
      tmp_c.each { |t| c_arr.push(t.micropost_id) }
      @microposts=Micropost.where(id: c_arr, visible: true).order("updated_at desc").limit(6)
    elsif params[:stock_id].nil? and params[:my_id].nil?
      @microposts=Micropost.where(visible: true).order("created_at desc").limit(6)
    elsif !params[:stock_id].nil? and params[:my_id].nil?
      @microposts=Micropost.where("stock_id=? and visible=?", params[:stock_id], true).order("created_at desc").limit(6)
    elsif params[:stock_id].nil? and !params[:my_id].nil?
      user=User.find(params[:my_id])
      @microposts=user.microposts.where(visible: true).order("created_at desc").limit(6)
    end
    microposts_a=[]
    @microposts.each do |m|
      tmp=m.attributes
      tmp["comment_number"]=m.comments.where(visible: true).size
      if (!m.goods.find_by_id(params[:uid]).nil?)
        tmp["good"]="true"
      else
        tmp["good"]="false"
      end
      tmp["good_number"]=m.goods.size
      if (!m.stock.nil?)
        tmp["stock_name"]=m.stock.name
      else
        tmp["stock_name"]="无"
      end

      if !params[:my_reply_id].nil?
        unread=Replyrelationship.where("replyuser_id=? and replymicropost_id=?", params[:uid], m.id)
        if unread.empty?
          tmp["unread"]=0
        else
          tmp["unread"]=unread[0].replyunread
        end
      else
        unread=Unreadrelation.where("unreaduser_id=? and unreadmicropost_id=?", params[:uid], m.id)
        if unread.empty?
          tmp["unread"]=0
        else
          tmp["unread"]=unread[0].unread
        end
      end

      microposts_a.push(tmp)
    end

    @result={}
    @result["microposts"]=microposts_a
    @result["unreadnum"]=Unreadmsg.where("msgfrom_id=?", params[:uid]).sum("msgunread")
    @result["unreadmicro"]=Unreadrelation.where("unreaduser_id=?", params[:uid]).sum("unread")
    @result["unreplymicro"]=Replyrelationship.where("replyuser_id=?",params[:uid]).sum("replyunread")
    render json: @result
  end

  def down_microposts_json
    if !params[:my_reply_id].nil?
      tmp_c=Comment.where("user_id=? and micropost_id<?", params[:my_reply_id],params[:down]).select("micropost_id").distinct
      c_arr=[]
      tmp_c.each { |t| c_arr.push(t.micropost_id) }
      @microposts=Micropost.where(id: c_arr, visible: true).order("updated_at desc").limit(6)
    elsif params[:stock_id].nil? and params[:my_id].nil?
      @microposts=Micropost.where("id < ? and visible=?", params[:down], true).order("created_at desc").limit(6)
    elsif !params[:stock_id].nil? and params[:my_id].nil?
      @microposts=Micropost.where("stock_id=? AND id < ? and visible=?", params[:stock_id], params[:down], true).order("created_at desc").limit(6)
    elsif params[:stock_id].nil? and !params[:my_id].nil?
      user=User.find(params[:my_id])
      @microposts=user.microposts.where("id < ? and visible=?", params[:down], true).order("created_at desc").limit(6)
    end
    microposts_a=[]
    @microposts.each do |m|
      tmp=m.attributes
      tmp["comment_number"]=m.comments.where(visible: true).size
      if (!m.goods.find_by_id(params[:uid]).nil?)
        tmp["good"]="true"
      else
        tmp["good"]="false"
      end
      tmp["good_number"]=m.goods.size
      if (!m.stock.nil?)
        tmp["stock_name"]=m.stock.name
      else
        tmp["stock_name"]="无"
      end
      if !params[:my_reply_id].nil?
        unread=Replyrelationship.where("replyuser_id=? and replymicropost_id=?", params[:uid], m.id)
        if unread.empty?
          tmp["unread"]=0
        else
          tmp["unread"]=unread[0].replyunread
        end
      else
        unread=Unreadrelation.where("unreaduser_id=? and unreadmicropost_id=?", params[:uid], m.id)
        if unread.empty?
          tmp["unread"]=0
        else
          tmp["unread"]=unread[0].unread
        end
      end
      microposts_a.push(tmp)
    end
    @result={}
    @result["microposts"]=microposts_a
    @result["unreadnum"]=Unreadmsg.where("msgfrom_id=?", params[:uid]).sum("msgunread")
    @result["unreadmicro"]=Unreadrelation.where("unreaduser_id=?", params[:uid]).sum("unread")
    @result["unreplymicro"]=Replyrelationship.where("replyuser_id=?",params[:uid]).sum("replyunread")
    render json: @result
  end

  def up_microposts_json
    if !params[:my_reply_id].nil?
      tmp_c=Comment.where("user_id=? and micropost_id>?", params[:my_reply_id],params[:up]).select("micropost_id").distinct
      c_arr=[]
      tmp_c.each { |t| c_arr.push(t.micropost_id) }
      @microposts=Micropost.where(id: c_arr, visible: true).order("updated_at desc").limit(6)
    elsif params[:stock_id].nil? and params[:my_id].nil?
      @microposts=Micropost.where("id > ? and visible=?", params[:up], true).order("created_at").limit(6)
    elsif !params[:stock_id].nil? and params[:my_id].nil?
      @microposts=Micropost.where("stock_id=? AND id and visible=? > ?", params[:stock_id], params[:up], true).order("created_at").limit(6)
    elsif params[:stock_id].nil? and !params[:my_id].nil?
      user=User.find(params[:my_id])
      @microposts=user.microposts.where("id > ? and visible=?", params[:up], true).order("created_at desc").limit(6)
    end
    microposts_a=[]
    @microposts.each do |m|
      tmp=m.attributes
      tmp["comment_number"]=m.comments.where(visible: true).size
      if (!m.goods.find_by_id(params[:uid]).nil?)
        tmp["good"]="true"
      else
        tmp["good"]="false"
      end
      tmp["good_number"]=m.goods.size
      if (!m.stock.nil?)
        tmp["stock_name"]=m.stock.name
      else
        tmp["stock_name"]="无"
      end
      if !params[:my_reply_id].nil?
        unread=Replyrelationship.where("replyuser_id=? and replymicropost_id=?", params[:uid], m.id)
        if unread.empty?
          tmp["unread"]=0
        else
          tmp["unread"]=unread[0].replyunread
        end
      else
        unread=Unreadrelation.where("unreaduser_id=? and unreadmicropost_id=?", params[:uid], m.id)
        if unread.empty?
          tmp["unread"]=0
        else
          tmp["unread"]=unread[0].unread
        end
      end
      microposts_a.push(tmp)
    end
    @result={}
    @result["microposts"]=microposts_a
    @result["unreadnum"]=Unreadmsg.where("msgfrom_id=?", params[:uid]).sum("msgunread")
    @result["unreadmicro"]=Unreadrelation.where("unreaduser_id=?", params[:uid]).sum("unread")
    @result["unreplymicro"]=Replyrelationship.where("replyuser_id=?",params[:uid]).sum("replyunread")
    render json: @result
  end

  def detail_micropost_json
    @micropost=Micropost.find(params[:mid])
    @comments=@micropost.comments.where(visible: true).order(updated_at: :desc)
    @micropost.comments=@comments
    unread=Unreadrelation.where("unreaduser_id=? and unreadmicropost_id=?", params[:uid], params[:mid])
    if !unread.empty?
      unread[0].unread=0
      unread[0].save
    end
    unreply=Replyrelationship.where("replyuser_id=? and replymicropost_id=?", params[:uid], params[:mid])
    if !unreply.empty?
      unreply[0].replyunread=0
      unreply[0].save
    end
    render json: @micropost.to_json(include: :comments, order: "updated_at desc");
  end

  def new_micropost_json
    user=User.find(params[:uid]);
    @micropost = user.microposts.new
    @micropost.content=params[:content]
    stock=Stock.find_by_code(params[:stock].to_s.split(",")[0])
    @micropost.stock=stock
    @resp={}
    if @micropost.save
      @resp["result"]="ok"
    else
      @resp["result"]="nook"
    end
    render json: @resp
  end

  def micropost_change_json
    @micropost=Micropost.find(params[:mid])
    @micropost.content=params[:content]
    stock=Stock.find_by_code(params[:stock].to_s.split(",")[0])
    @micropost.stock=stock
    @resp={}
    if @micropost.save
      @resp["result"]="ok"
    else
      @resp["result"]="nook"
    end
    render json: @resp
  end

  def new_comment_json
    @micropost=Micropost.find(params[:mid])
    user=User.find(params[:uid])
    comment=@micropost.comments.build(msg: params[:msg])
    comment.user=user
    @resp={}
    if comment.save
      anon=@micropost.anons.find_by_anonuser_id(user.id)
      if (anon.nil?)
        @micropost.anonusers.push(user)
        anon=@micropost.anons.find_by_anonuser_id(user)
        anon.anonnum=@micropost.anonnum
        if anon.save
          @micropost.anonnum=@micropost.anonnum+1
          @micropost.save
        end
      end
      comment.anonid=@micropost.anons.find_by_anonuser_id(comment.user.id).anonnum.to_s
      comment.save
      if user!=@micropost.user
        @unread=Unreadrelation.find_by(unreaduser_id: @micropost.user.id, unreadmicropost_id: @micropost.id)
        if (@unread.nil?)
          @unread=Unreadrelation.create(unreaduser_id: @micropost.user.id, unreadmicropost_id: @micropost.id, unread: 0)
        end
        @unread.unread+=1
        @unread.save
      end

      reply=Replyrelationship.find_by(replyuser_id:params[:uid],replymicropost_id:params[:mid])
      if reply.nil?
        reply=Replyrelationship.create(replyuser_id:params[:uid],replymicropost_id:params[:mid],replyunread:0)
      end
      otherreplies=Replyrelationship.where(replymicropost_id: params[:mid])

      @msg={}

      otherreplies.each do |r|
        r.replyunread+=1
        r.save
        @msg["title"]="你回复的帖子有新的回复～"
        @msg["content"]="你回复的帖子有新的回复～"
        @msg["topshow"]="你回复的帖子有新的回复～"
        @msg["user_id"]=r.replyuser_id
        @msg["msgtype"]="4"
        $redis.publish('static',@msg.to_json)
      end
      @resp["result"]="ok"
      @resp["comments"]=Micropost.find(params[:mid]).comments.where(visible: true)

      @msg["msgtype"]="2"
      # @msg["user_id"]=@micropost.user_id.to_s
      @msg["title"]="你有新的回复～"
      @msg["content"]="你有新的回复～"
      @msg["topshow"]="你有新的回复～"
      @msg["user_id"]=@micropost.user_id
      $redis.publish('static', @msg.to_json)
    else
      @resp["result"]="nook"
    end
    render json: @resp
  end

  def del_comment_json
    comment=Comment.find(params[:cid])
    comment.visible=false
    @resp={};
    if comment.save
      @resp["result"]="ok"
      @resp["comments"]=comment.micropost.comments.where(visible: true)
    else
      @resp["result"]="nook"
    end
    render json: @resp
  end

  def login_json
    user = User.authenticate_user(params[:username], params[:passwd])
    @resp={}
    if user
      if  user.update_column(:mobile_toke, SecureRandom.urlsafe_base64)
        @resp["result"]="ok"
        @resp["token"]=user.mobile_toke;
        @resp["user_id"]=user.id
      else
        @resp["result"]="nook"
      end
    else
      @resp["result"]="nook"
    end
    render json: @resp
  end

  def login_token_json
    user=User.find(params[:uid])
    @resp={}
    if user.mobile_toke==params[:token]
      @resp["result"]="ok"
    else
      @resp["result"]="nook"
    end
    render json: @resp
  end

  def reg_json
    user=User.find_by_email(params[:email])
    @resp={}
    if user
      @resp["checkemail"]="nook"
    else
      @user = User.new()
      @user.name=params[:name]
      @user.email=params[:email]
      @user.password=params[:passwd]
      @user.phone=params[:phone]

      @resp["checkemail"]="ok"

      if @user.save!
        @user.update_column(:email_confirmed, true)
        @resp["result"]="ok"
      else
        @resp["result"]="nook"
      end
    end
    render json: @resp
  end

  def micropost_good_json
    user=User.find(params[:uid])
    micropost=Micropost.find(params[:mid])
    user.begoods<<micropost
    @resp={}
    @resp["result"]="ok"
    render json: @resp
  end

  def micropost_del_json
    micropost=Micropost.find(params[:mid])
    micropost.visible=false
    @resp={}
    if micropost.save
      @resp["result"]="ok"
    else
      @resp["result"]="nook"
    end
    render json: @resp
  end

  def micropost_nogood_json
    user=User.find(params[:uid])
    micropost=Micropost.find(params[:mid])
    user.begoods.delete(micropost)
    @resp={}
    @resp["result"]="ok"
    render json: @resp
  end

  def messages_json
    @resp={}
    messages=Pmsg.where("(fromuser_id=? AND touser_id=?) OR (fromuser_id=? AND touser_id=?)", params[:from_id], params[:to_id],
                        params[:to_id], params[:from_id]).order("created_at")
    unreadmsg=Unreadmsg.where("msgfrom_id=? and msgto_id=?", params[:from_id], params[:to_id])[0]
    unreadmsg.msgunread=0
    unreadmsg.save
    if messages.empty?
      @resp["result"]="ok"
      @resp["msgArray"]="[]"
    else
      @resp["result"]="ok"
      @resp["msgArray"]=messages
    end
    render json: @resp
  end

  def new_message_json
    @resp={}
    pmsg=Pmsg.new
    pmsg.fromuser_id=params[:from_id]
    pmsg.touser_id=params[:to_id]
    pmsg.msg=params[:msg]
    p1=Pmsg.where("fromuser_id=? and touser_id=?", params[:from_id], params[:to_id])
    p2=Pmsg.where("fromuser_id=? and touser_id=?", params[:to_id], params[:from_id])
    if !p1.empty?
      anonnum=p1[0].anonnum
      anontonum=p1[0].anontonum
    elsif !p2.empty?
      anonnum=p2[0].anontonum
      anontonum=p2[0].anonnum
    elsif p1.empty? and p2.empty?
      to_user=User.find(params[:to_id])
      currentuser=User.find(params[:uid])
      if currentuser!=to_user
        anonnum=currentuser.anonnum
        currentuser.update_column(:anonnum, anonnum+1)
        anontonum=to_user.anonnum
        to_user.update_column(:anonnum, anontonum+1)
      else
        anontonum=anonnum=0
      end
    end
    pmsg.anonnum=anonnum
    pmsg.anontonum=anontonum
    if pmsg.save
      unreadmsg=Unreadmsg.where("msgfrom_id=? and msgto_id=?", params[:to_id], params[:from_id])
      if unreadmsg.empty?
        unreadmsg=Unreadmsg.create(msgfrom_id: params[:to_id], msgto_id: params[:from_id])
      else
        unreadmsg=unreadmsg[0]
      end
      if params[:from_id]!=params[:to_id]
        unreadmsg.msgunread+=1
      end
      if unreadmsg.save
        @resp["result"]="ok"
        @resp["msg"]=pmsg
        @msg={}
        @msg["msgtype"]="3"
        @msg["user_id"]=params[:to_id]
        @msg["title"]="你有新的私信～"
        @msg["content"]="你有新的私信～"
        @msg["topshow"]="你有新的私信～"
        $redis.publish('static', @msg.to_json);
      else
        @resp["result"]="nook"
      end
    else
      @resp["result"]="nook"
    end
    render json: @resp
  end


  def message_user_json
    p1=Pmsg.where("fromuser_id=?", params[:uid])
    p2=Pmsg.where("touser_id=?", params[:uid])

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

    @msginfo.each do |t|
      unread=Unreadmsg.where("msgfrom_id=? and msgto_id=?", params[:uid], t["touser"])
      if !unread.empty?
        t["unreadnum"]=unread[0].msgunread
        t["updated_at"]=unread[0].updated_at
      else
        t["unreadnum"]=0
        t["updated_at"]=Pmsg.where("(fromuser_id=? and touser_id=?) or (touser_id=? and fromuser_id=?)", t["touser"], params[:uid], t["touser"], params[:uid])[0].created_at
      end
    end

    @msginfo=@msginfo.sort_by { |t| t["updated_at"] }.reverse

    render json: @msginfo
  end

  def api_add_chat
    @resp={}
    $redis.publish('static', params[:msg].to_s);
    render json: @resp
  end

  private

  def checktoken
    user=User.find(params[:uid])
    @resp={}
    if user.mobile_toke!=params[:token]
      @resp["result"]="noauth"
      render json: @resp
    end
  end
end