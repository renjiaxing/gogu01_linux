class Comment < ActiveRecord::Base
  belongs_to :micropost
  belongs_to :user

  def self.push_single_account(req_params={})
    conn = Faraday.new(:url => 'http://openapi.xg.qq.com') do |faraday|
      faraday.request :url_encoded # form-encode POST params
      faraday.response :logger # log requests to STDOUT
      faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
    end
    req_params.merge!({
                          access_id:2200120344,
                          timestamp:Time.now.to_i,
                          environment:1  #生产环境用1
                      })
    p=req_params
    # p.merge!({message: message, message_type: message_type, account: account, access_id: access_id, timestamp: Time.now.to_i, environment: environment}
    params_string = p.sort.map { |h| h.join('=') }.join
    sign = Digest::MD5.hexdigest("POSTopenapi.xg.qq.com/v2/push/single_account#{params_string}72371c5e43c99b8a4a845ff995bef03c")
    p.merge!({sign: sign})

    result=conn.post do |req|
      req.url '/v2/push/single_account'
      req.body = p
    end

    p result
  end

  def self.save_comment(micropost, user, comment)
    anon=micropost.anons.find_by_anonuser_id(user.id)
    if anon.nil?
      micropost.anonusers.push(user)
      anon=micropost.anons.find_by_anonuser_id(user)
      anon.anonnum=micropost.anonnum
      if anon.save
        micropost.anonnum=micropost.anonnum+1
        micropost.save
      end
    end
    comment.anonid=micropost.anons.find_by_anonuser_id(comment.user.id).anonnum.to_s
    comment.save

    msg={}
    if user!=micropost.user
      unread=Unreadrelation.find_by(unreaduser_id: micropost.user.id, unreadmicropost_id: micropost.id)
      if unread.nil?
        unread=Unreadrelation.create(unreaduser_id: micropost.user.id, unreadmicropost_id: micropost.id, unread: 0)
      end
      unread.unread+=1
      unread.save

      msg["msgtype"]="2"
      msg["title"]="你有新的回复～"
      msg["content"]="你有新的回复～"
      msg["topshow"]="你有新的回复～"
      msg["user_id"]=micropost.user_id
      $redis.publish('static', msg.to_json)

      content={}
      content_alert={}
      content_alert["alert"]="你有新的回复～"
      content["aps"]=content_alert

      req_params={}
      req_params.merge!({message: content.to_json,
                         message_type: 1,
                         account: "account"+micropost.user_id.to_s})
      begin
        self.push_single_account(req_params)
      rescue Exception => e
        # push_single_account("1",0,content)
      end
    end

    reply=Replyrelationship.find_by(replyuser_id: user.id, replymicropost_id: micropost.id)
    if reply.nil?
      reply=Replyrelationship.create(replyuser_id: user.id, replymicropost_id: micropost.id, replyunread: 0)
    end
    otherreplies=Replyrelationship.where("replyuser_id!=? AND replymicropost_id=?", user.id, micropost.id)



    otherreplies.each do |r|
      r.replyunread+=1
      r.save
      msg["title"]="你回复的帖子有新的回复～"
      msg["content"]="你回复的帖子有新的回复～"
      msg["topshow"]="你回复的帖子有新的回复～"
      msg["user_id"]=r.replyuser_id
      msg["msgtype"]="4"
      $redis.publish('static', msg.to_json)

      content={}
      content_alert={}
      content_alert["alert"]="你回复的帖子有新的回复～"
      content["aps"]=content_alert

      req_params={}
      req_params.merge!({message: content.to_json,
                         message_type: 1,
                         account: "account"+r.replyuser_id.to_s})
      begin
        self.push_single_account(req_params)
      rescue Exception => e
        # push_single_account("1",0,content)
      end
    end


  end
end
