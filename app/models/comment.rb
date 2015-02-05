class Comment < ActiveRecord::Base
  belongs_to :micropost
  belongs_to :user

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
    end


  end
end
