class ApijsonController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :checktoken, except: [:login_json, :login_token_json, :reg_json, :version_json,
                                      :api_add_chat, :forget_password_json]

  def version_json
    tmp={}
    tmp["version"]=13
    tmp["version_name"]="股刺网"
    tmp["version_desc"]="股刺网有新版本哦，赶快下载更新吧~~"
    render json: tmp
  end

  def active_apple_micro_push_json
    user=User.find(params[:uid])
    user.update_column(:apple_micro_push, 1);
    resp={}
    resp[:result]="ok"

    render json: resp
  end

  def active_android_micro_push_json
    user=User.find(params[:uid])
    user.update_column(:android_micro_push, 1);
    resp={}
    resp[:result]="ok"

    render json: resp
  end

  def deactive_android_micro_push_json
    user=User.find(params[:uid])
    user.update_column(:android_micro_push, 0);
    resp={}
    resp[:result]="ok"

    render json: resp
  end

  def active_android_reply_push_json
    user=User.find(params[:uid])
    user.update_column(:android_reply_push, 1);
    resp={}
    resp[:result]="ok"

    render json: resp
  end

  def deactive_android_reply_push_json
    user=User.find(params[:uid])
    user.update_column(:android_reply_push, 0);
    resp={}
    resp[:result]="ok"

    render json: resp
  end

  def active_android_chat_push_json
    user=User.find(params[:uid])
    user.update_column(:android_chat_push, 1);
    resp={}
    resp[:result]="ok"

    render json: resp
  end

  def deactive_android_chat_push_json
    user=User.find(params[:uid])
    user.update_column(:android_chat_push, 0);
    resp={}
    resp[:result]="ok"

    render json: resp
  end


  def polls_json
    polls=Poll.order("created_at desc").limit(6)
    render json: polls.to_json(include: {questions: {include: :answers}})
  end

  def my_polls_json
    user=User.find(params[:uid])
    polls=user.polls.order("created_at desc").distinct.limit(6)
    render json: polls
  end

  def up_my_polls_json
    user=User.find(params[:uid])
    p=Poll.find(params[:max])
    polls=user.polls.where("polls.created_at > ?", p.created_at).order("created_at desc").distinct.limit(6).reverse
    render json: polls
  end

  def down_my_polls_json
    user=User.find(params[:uid])
    p=Poll.find(params[:min])
    polls=user.polls.where("polls.created_at < ?", p.created_at).order("created_at desc").distinct.limit(6)
    render json: polls
  end

  def down_polls_json
    p=Poll.find(params[:min])
    polls=Poll.where("created_at < ?", p.created_at).order("created_at desc").limit(6)
    render json: polls.to_json(include: {questions: {include: :answers}})
  end

  def up_polls_json
    p=Poll.find(params[:max])
    polls=Poll.where("created_at > ?", p.created_at).order("created_at").limit(6)
    render json: polls.to_json(include: {questions: {include: :answers}})
  end

  def detail_question_json
    poll=Poll.find(params[:id])
    user=User.find(params[:uid])
    # render json:p.questions.to_json(include: :answers)
    ps=poll.attributes
    ps["voted"]=user.voted_for?(poll).to_s

    questions=poll.questions
    qs=[]
    questions.each do |q|
      answers=q.answers
      qtmp=q.attributes
      as=[]
      answers.each do |a|
        atmp=a.attributes
        if a.users.include?(user)
          atmp["choose"]="true"
        else
          atmp["choose"]="false"
        end
        atmp["percentage"]=q.normalized_votes_for(a)
        as.push(atmp)
      end
      qtmp["answers"]=as
      qs.push(qtmp)
    end
    ps["questions"]=qs
    render json: ps
  end

  def vote_json
    @poll = Poll.find_by_id(params[:pid])
    user=User.find(params[:uid])
    resp={}
    if user && params[:pid] && params[:answer]
      @poll.questions.each do |q|
        @option=q.answers.find_by_id(params[:answer][q.id.to_s])
        if @option && @poll && !user.voted_for?(@poll)
          @option.votes.create({user_id: user.id, question_id: q.id, poll_id: @poll.id})
          @poll.votenum=@poll.questions[0].votes_summary
          @poll.save
          resp["result"]="ok"
        else
          resp["result"]="nook"
        end
      end
    else
      resp["result"]="nook"
    end
    render json: resp
  end

  def deactive_apple_micro_push_json
    user=User.find(params[:uid])
    user.update_column(:apple_micro_push, 0);
    resp={}
    resp[:result]="ok"

    render json: resp
  end

  def active_apple_reply_push_json
    user=User.find(params[:uid])
    user.update_column(:apple_reply_push, 1);
    resp={}
    resp[:result]="ok"

    render json: resp
  end

  def deactive_apple_reply_push_json
    user=User.find(params[:uid])
    user.update_column(:apple_reply_push, 0);
    resp={}
    resp[:result]="ok"

    render json: resp
  end

  def active_apple_chat_push_json
    user=User.find(params[:uid])
    user.update_column(:apple_chat_push, 1);
    resp={}
    resp[:result]="ok"

    render json: resp
  end

  def deactive_apple_chat_push_json
    user=User.find(params[:uid])
    user.update_column(:apple_chat_push, 0);
    resp={}
    resp[:result]="ok"

    render json: resp
  end

  def my_push_info_json
    user=User.find(params[:uid])
    resp={}
    if user.apple_chat_push
      resp[:apple_chat_push]="true"
    else
      resp[:apple_chat_push]="no"
    end

    if user.apple_micro_push
      resp[:apple_micro_push]="true"
    else
      resp[:apple_micro_push]="no"
    end
    if user.apple_reply_push
      resp[:apple_reply_push]="true"
    else
      resp[:apple_reply_push]="no"
    end


    render json: resp
  end

  def main_json
    result={}
    result["unreadnum"]=Unreadmsg.where("msgfrom_id=?", params[:uid]).sum("msgunread")
    sum=0
    tmp_u=Unreadrelation.where("unreaduser_id=?", params[:uid])
    tmp_u.each { |t| sum+=t.unread if t.unreadmicropost&&t.unreadmicropost.visible==true }
    result["unreadmicro"]=sum
    # result["unreadmicro"]=Unreadrelation.where("unreaduser_id=?", uid).sum("unread")
    sum=0
    tmp_r=Replyrelationship.where("replyuser_id=?", params[:uid])
    tmp_r.each { |t| sum+=t.replyunread if t.replymicropost&&t.replymicropost.visible==true }
    result["unreplymicro"]=sum
    # result["unreplymicro"]=Replyrelationship.where("replyuser_id=?", uid).sum("replyunread")
    user=User.find(params[:uid])
    result["randint"]=user.randint
    result["android_micro_push"]=user.android_micro_push
    result["android_reply_push"]=user.android_reply_push
    result["android_chat_push"]=user.android_chat_push

    render json: result
  end

  def check_stock_json
    if params[:code].include?(",")
      code=params[:code].split(",")[0]
    else
      code=params[:code]
    end
    stocks=Stock.where("(code LIKE ?) OR (name LIKE ?) OR (shortname LIKE ?)", "%"+code+"%", "%"+code+"%", "%"+code+"%").limit(params[:maxRows])
    result=[]
    stocks.each do |s|
      tmp=s.attributes
      if s.mystocks.where("user_id=?", params[:uid]).first.nil?
        tmp["follow"]="false"
      else
        tmp["follow"]="true"
      end
      result.push(tmp)
    end
    render json: result
  end

  def mystock_json
    stocks=Stock.joins(:mystocks).where("mystocks.user_id=?", params[:uid])
    @resp={}
    @resp["result"]="ok"
    @resp["stocks"]=stocks
    render json: @resp
  end

  def addstock_json
    @resp={}
    existstock=Mystock.where("user_id=? and stock_id=?", params[:uid], params[:sid]).first
    if existstock.nil?
      mystock=Mystock.new(user_id: params[:uid], stock_id: params[:sid])
      if mystock.save
        @resp["result"]="ok"
      else
        @resp["result"]="nook"
      end
    else
      @resp["result"]="ok"
    end

    render json: @resp

  end

  def delstock_json
    @resp={}
    existstock=Mystock.where("user_id=? and stock_id=?", params[:uid], params[:sid]).first
    if existstock.nil?
      @resp["result"]="ok"
    else
      existstock.destroy
      @resp["result"]="ok"
    end

    render json: @resp
  end

  def change_password_json
    user=User.find(params[:uid])
    @resp={}
    if user.authenticate(params[:oldpwd])
      user.password=params[:newpwd]
      user.password_confirmation=params[:newpwd]
      if user.save
        @resp["result"]="ok"
      else
        @resp["result"]="nook"
      end
    else
      @resp["result"]="pwdnook"
    end
    render json: @resp
  end

  def new_advice_json
    advice=Advice.new
    advice.title=params[:title]
    advice.content=params[:content]

    @resp={}
    if advice.save
      @resp["result"]="ok"
    else
      @resp["result"]="nook"
    end

    render json: @resp

  end

  def forget_password_json
    user=User.find_by_email(params[:email])
    result={}
    if !user.nil?
      user.send_password_reset
      result["checkemail"]="ok"
      result["result"]="ok"
    else
      result["checkemail"]="nook"
      result["result"]="nook"
    end
    render json: result
  end

  def new_micropost_json
    @micropost = Micropost.new(micropost_params)
    @micropost.randint=rand(100)
    if Stock.find_by_code(params[:micropost][:stock_id]).nil?
      @micropost.stock_id=nil
    else
      @micropost.stock_id=Stock.find_by_code(params[:micropost][:stock_id]).id
    end
    @resp={}
    if @micropost.save
      @resp["result"]="ok"
    else

      if @micropost.stock_id.nil?
        @resp["result"]="stocknook"
      else
        @resp["result"]="nook"
      end
    end
    render json: @resp.to_json
  end

  def microposts_json
    @microposts=[]
    if !params[:my_reply_id].nil?
      @microposts=Micropost.joins(:replyrelationships).
          where("microposts.visible=? and replyrelationships.replyuser_id=?",
                true, params[:my_reply_id]).order("microposts.created_at desc").limit(6)
    elsif !params[:stock_id].nil?
      @microposts=Micropost.where("stock_id=? and visible=?", params[:stock_id], true).order("created_at desc").limit(6)
    elsif !params[:my_id].nil?
      @microposts=Micropost.where("user_id=? and visible=?", params[:my_id], true).order("created_at desc").limit(6)
    elsif !params[:my_stocks].nil?
      user_stocks=[]
      user=User.find(params[:my_stocks])
      user.mystocks.each do |t|
        user_stocks<<t.stock
      end
      @microposts=Micropost.where(stock: user_stocks, visible: true).order("created_at desc").limit(6)
    else
      @microposts=Micropost.where(visible: true).order("created_at desc").limit(6)
    end
    # if !params[:my_reply_id].nil?
    #   tmp_c=Replyrelationship.where("replyuser_id=? and replyunread!=?", params[:my_reply_id], 0).order("updated_at desc")
    #   c_arr=[]
    #   if !tmp_c.empty?
    #     tmp_c.each { |t| c_arr.push(t.replymicropost) if t.replymicropost.visible==true }
    #   end
    #
    #   tmp_c=Replyrelationship.where("replyuser_id=? and replyunread=?", params[:my_reply_id], 0).order("updated_at desc")
    #
    #   if !tmp_c.empty?
    #     tmp_c.each { |t| c_arr.push(t.replymicropost) if t.replymicropost.visible==true }
    #   end
    #
    #   @microposts=[]
    #   if c_arr.size>6
    #     i=0
    #     while i<6 do
    #       @microposts.push(c_arr[i])
    #       i+=1
    #     end
    #   else
    #     c_arr.each do |t|
    #       @microposts.push(t)
    #     end
    #   end
    #   # @microposts=Micropost.where(id: c_arr, visible: true).limit(6)
    # elsif params[:stock_id].nil? and params[:my_id].nil?
    #   @microposts=Micropost.where(visible: true).order("created_at desc").limit(6)
    # elsif !params[:stock_id].nil? and params[:my_id].nil?
    #   @microposts=Micropost.where("stock_id=? and visible=?", params[:stock_id], true).order("created_at desc").limit(6)
    # elsif params[:stock_id].nil? and !params[:my_id].nil?
    #   # user=User.find(params[:my_id])
    #   # @microposts=user.microposts.where(visible: true).order("created_at desc").limit(6)
    #
    #   allunreadmicro=Unreadrelation.where("unreaduser_id=? AND unread!=?", params[:my_id], 0)
    #   unreadmicroid=[]
    #   if !allunreadmicro.empty?
    #     allunreadmicro.each { |t| unreadmicroid<<t.unreadmicropost_id }
    #   end
    #   unreadmicro=allunreadmicro.order("updated_at desc").limit(6)
    #   @microposts=[]
    #   if !unreadmicro.empty?
    #     unreadmicro.each { |t| @microposts<<t.unreadmicropost if t.unreadmicropost.visible==true }
    #   end
    #   if unreadmicro.size<6
    #     difsize=6-unreadmicro.size
    #     if unreadmicroid.empty?
    #       readmicro=Micropost.where("user_id=? and visible=?", params[:my_id], true).order("updated_at desc").limit(difsize)
    #     else
    #       readmicro=Micropost.where("user_id=? AND id not in(?) and visible=?", params[:my_id], unreadmicroid, true).order("updated_at desc").limit(difsize)
    #     end
    #     @microposts=@microposts|readmicro
    #   end
    # end

    @result=render_microposts_api_json(@microposts, params[:uid], params[:my_reply_id])
    render json: @result
  end

  def down_microposts_json
    @microposts=[]
    m=Micropost.find(params[:down])
    if !params[:my_reply_id].nil?
      @microposts=Micropost.joins(:replyrelationships).
          where("microposts.visible=? and microposts.created_at<? and replyrelationships.replyuser_id=?",
                true, m.created_at, params[:my_reply_id]).order("microposts.created_at desc").limit(6)
    elsif !params[:stock_id].nil?
      @microposts=Micropost.where("stock_id=? and visible=? and created_at<?", params[:stock_id], true, m.created_at).
          order("created_at desc").limit(6)
    elsif !params[:my_id].nil?
      @microposts=Micropost.where("user_id=? and visible=? and created_at<?", params[:my_id], true, m.created_at).
          order("created_at desc").limit(6)
    elsif !params[:my_stocks].nil?
      user_stocks=[]
      user=User.find(params[:my_stocks])
      user.mystocks.each do |t|
        user_stocks<<t.stock
      end
      @microposts=Micropost.where(stock: user_stocks, visible: true).where("created_at<?", m.created_at).
          order("created_at desc").limit(6)
    else
      @microposts=Micropost.where("visible=? and created_at<?", true, m.created_at).order("created_at desc").limit(6)
    end
    # if !params[:my_reply_id].nil?
    #   tmp_c=Replyrelationship.where("replyuser_id=? and replyunread!=?", params[:my_reply_id], 0).order("updated_at desc")
    #   c_arr=[]
    #   if !tmp_c.empty?
    #     tmp_c.each { |t| c_arr.push(t.replymicropost) if t.replymicropost.visible==true }
    #   end
    #   tmp_c=Replyrelationship.where("replyuser_id=? and replyunread=?", params[:my_reply_id], 0).order("updated_at desc")
    #   if !tmp_c.empty?
    #     tmp_c.each { |t| c_arr.push(t.replymicropost) if t.replymicropost.visible==true }
    #   end
    #   i=0
    #   c_arr.each_with_index do |t, index|
    #     if t.id==params[:down].to_i
    #       i=index
    #       break
    #     end
    #   end
    #   c_arr=c_arr[i+1..c_arr.size]
    #   @microposts=[]
    #   if c_arr.size>6
    #     i=0
    #     while i<6 do
    #       @microposts.push(c_arr[i])
    #       i+=1
    #     end
    #   else
    #     c_arr.each do |t|
    #       @microposts.push(t)
    #     end
    #   end
    #   # tmp_c=Comment.where("user_id=? and micropost_id<? and visible=?", params[:my_reply_id],params[:down],true).select("micropost_id").distinct
    #   # c_arr=[]
    #   # tmp_c.each { |t| c_arr.push(t.micropost_id) }
    #   # @microposts=Micropost.where(id: c_arr, visible: true).order("updated_at desc").limit(6)
    # elsif params[:stock_id].nil? and params[:my_id].nil?
    #   @microposts=Micropost.where("id < ? and visible=?", params[:down], true).order("created_at desc").limit(6)
    # elsif !params[:stock_id].nil? and params[:my_id].nil?
    #   @microposts=Micropost.where("stock_id=? AND id < ? and visible=?", params[:stock_id], params[:down], true).order("created_at desc").limit(6)
    # elsif params[:stock_id].nil? and !params[:my_id].nil?
    #   # user=User.find(params[:my_id])
    #   # @microposts=user.microposts.where("id < ? and visible=?", params[:down], true).order("created_at desc").limit(6)
    #   allunreadmicro=Unreadrelation.where("unreaduser_id=? AND unread!=?", params[:my_id], 0)
    #   unreadmicroid=[]
    #   if !allunreadmicro.empty?
    #     allunreadmicro.each { |t| unreadmicroid<<t.unreadmicropost_id }
    #   end
    #   find_down=Unreadrelation.where("unreaduser_id=? AND unread!=? AND unreadmicropost_id=?", params[:my_id], 0, params[:down]).first
    #   if !find_down.nil?
    #     unreadmicro=Unreadrelation.where("unreaduser_id=? AND unread!=? AND updated_at<?", params[:my_id], 0, find_down.updated_at).order("updated_at desc").limit(6)
    #     @microposts=[]
    #     if !unreadmicro.empty?
    #       unreadmicro.each { |t| @microposts<<t.unreadmicropost if t.unreadmicropost.visible==true }
    #     end
    #     if unreadmicro.size<6
    #
    #       difsize=6-unreadmicro.size
    #       if unreadmicroid.empty?
    #         readmicro=Micropost.where("user_id=? and visible=?", params[:my_id], true).order("updated_at desc").limit(difsize)
    #       else
    #         readmicro=Micropost.where("user_id=? AND id not in(?) and visible=?", params[:my_id], unreadmicroid, true).order("updated_at desc").limit(difsize)
    #       end
    #       @microposts=@microposts|readmicro
    #     end
    #   else
    #     find_down=Micropost.find(params[:down])
    #     @microposts=Micropost.where("user_id=? AND id not in(?) AND visible=? AND updated_at<?", params[:my_id],
    #                                 unreadmicroid, true, find_down.updated_at).order("updated_at desc").limit(6)
    #   end
    #
    # end

    @result=render_microposts_api_json(@microposts, params[:uid], params[:my_reply_id])
    render json: @result

  end

  def up_microposts_json
    @microposts=[]
    m=Micropost.find(params[:up])
    if !params[:my_reply_id].nil?
      @microposts=Micropost.joins(:replyrelationships).
          where("microposts.visible=? and microposts.created_at>? and replyrelationships.replyuser_id=?",
                true, m.created_at, params[:my_reply_id]).order("microposts.created_at").limit(6).reverse
    elsif !params[:stock_id].nil?
      @microposts=Micropost.where("stock_id=? and visible=? and created_at>?", params[:stock_id], true, m.created_at).
          order("created_at").limit(6).reverse
    elsif !params[:my_id].nil?
      @microposts=Micropost.where("user_id=? and visible=? and created_at>?", params[:my_id], true, m.created_at).
          order("created_at").limit(6).reverse
    elsif !params[:my_stocks].nil?
      user_stocks=[]
      user=User.find(params[:my_stocks])
      user.mystocks.each do |t|
        user_stocks<<t.stock
      end
      @microposts=Micropost.where(stock: user_stocks, visible: true).where("created_at>?", m.created_at).
          order("created_at").limit(6).reverse
    else
      @microposts=Micropost.where("visible=? and created_at>?", true, m.created_at).order("created_at").limit(6).reverse
    end
    # if !params[:my_reply_id].nil?
    #   tmp_c=Replyrelationship.where("replyuser_id=? and replyunread!=?", params[:my_reply_id], 0).order("updated_at desc")
    #   c_arr=[]
    #   if !tmp_c.empty?
    #     tmp_c.each { |t| c_arr.push(t.replymicropost) if t.replymicropost.visible==true }
    #   end
    #   tmp_c=Replyrelationship.where("replyuser_id=? and replyunread=?", params[:my_reply_id], 0).order("updated_at desc")
    #   if !tmp_c.empty?
    #     tmp_c.each { |t| c_arr.push(t.replymicropost) if t.replymicropost.visible==true }
    #   end
    #   @microposts=[]
    #   if c_arr.size>=6
    #     i=0
    #     while i<6 do
    #       @microposts.push(c_arr[i])
    #       i+=1
    #     end
    #   else
    #     c_arr.each do |t|
    #       @microposts.push(t)
    #     end
    #   end
    #   # tmp_c=Comment.where("user_id=? and micropost_id>? and visible=?", params[:my_reply_id],params[:up],true).select("micropost_id").distinct
    #   # c_arr=[]
    #   # tmp_c.each { |t| c_arr.push(t.micropost_id) }
    #   # @microposts=Micropost.where(id: c_arr, visible: true).order("updated_at desc").limit(6)
    # elsif params[:stock_id].nil? and params[:my_id].nil?
    #   @microposts=Micropost.where("id > ? and visible=?", params[:up], true).order("created_at").limit(6)
    # elsif !params[:stock_id].nil? and params[:my_id].nil?
    #   @microposts=Micropost.where("stock_id=? AND id and visible=? > ?", params[:stock_id], params[:up], true).order("created_at").limit(6)
    # elsif params[:stock_id].nil? and !params[:my_id].nil?
    #   # user=User.find(params[:my_id])
    #   # @microposts=user.microposts.where("id > ? and visible=?", params[:up], true).order("created_at desc").limit(6)
    #   allunreadmicro=Unreadrelation.where("unreaduser_id=? AND unread!=?", params[:my_id], 0)
    #   unreadmicroid=[]
    #   if !allunreadmicro.empty?
    #     allunreadmicro.each { |t| unreadmicroid<<t.unreadmicropost_id }
    #   end
    #   unreadmicro=allunreadmicro.order("updated_at desc").limit(6)
    #   @microposts=[]
    #   if !unreadmicro.empty?
    #     unreadmicro.each { |t| @microposts<<t.unreadmicropost if t.unreadmicropost.visible==true }
    #   end
    #   if unreadmicro.size<6
    #     difsize=6-unreadmicro.size
    #     if unreadmicroid.empty?
    #       readmicro=Micropost.where("user_id=? and visible=?", params[:my_id], true).order("updated_at desc").limit(difsize)
    #     else
    #       readmicro=Micropost.where("user_id=? AND id not in(?) and visible=?", params[:my_id], unreadmicroid, true).order("updated_at desc").limit(difsize)
    #     end
    #     @microposts=@microposts|readmicro
    #   end
    # end

    @result=render_microposts_api_json(@microposts, params[:uid], params[:my_reply_id])
    render json: @result

  end

  def detail_micropost_json
    @micropost=Micropost.find(params[:mid])
    @comments=@micropost.comments.where(visible: true).order(updated_at: :desc)
    @micropost.comments=@comments
    unread=Unreadrelation.where("unreaduser_id=? and unreadmicropost_id=?", params[:uid], params[:mid]).first
    if !unread.nil?
      unread.unread=0
      unread.save
    end
    unreply=Replyrelationship.where("replyuser_id=? and replymicropost_id=?", params[:uid], params[:mid]).first
    if !unreply.nil?
      unreply.replyunread=0
      unreply.save
    end
    render json: @micropost.to_json(include: :comments, order: "updated_at desc");
  end

  def change_micropost_json
    micropost=Micropost.find(params[:mid])
    params[:micropost][:stock_id]=Stock.find_by_code(params[:micropost][:stock_id]).id
    @resp={}
    if micropost.update_attributes(micropost_params)
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
      Comment.save_comment(@micropost, user, comment, user.apple_micro_push, user.apple_reply_push)

      @resp["result"]="ok"
      @resp["comments"]=Micropost.find(params[:mid]).comments.where(visible: true)
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
      if user.update_column(:mobile_toke, SecureRandom.urlsafe_base64)
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
    # if params[:code]!=Userconfig.find_by_name("code").value
    #   @resp["checkcode"]="nook"
    # elsif user
    #   @resp["checkcode"]="ok"
    #new add
    if user
      #add
      @resp["checkemail"]="nook"
    else
      @user = User.new()
      @user.name=params[:name]
      @user.email=params[:email]
      @user.password=params[:passwd]
      @user.phone=params[:phone]

      @resp["checkemail"]="ok"
      @resp["checkcode"]="ok"

      if @user.save
        @user.update_column(:email_confirmed, true)
        @user.update_column(:randint, rand(100))
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
    unreadmsg=Unreadmsg.where("(msgfrom_id=? and msgto_id=?) OR (msgto_id=? and msgfrom_id=?)", params[:from_id], params[:to_id], params[:from_id], params[:to_id])
    unreadmsg.each do |m|
      m.msgunread=0
      m.save
    end
    # unreadmsg.save
    # if messages.empty?
    #   @resp["result"]="ok"
    #   @resp["msgArray"]="[]"
    # else
    #   @resp["result"]="ok"
    #   @resp["msgArray"]=messages
    # end
    @resp["result"]="ok"
    @resp["msgArray"]=messages
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
        # $redis.publish('static', @msg.to_json);

        if to_user.android_chat_push
          to_user.umeng_android_push_send("你有新的私信~", "你有新的私信~", "你有新的私信~", "customizedcast", "gogu02", params[:to_id].to_s, "go_activity", "com.rjx.gogu02.aty.MyChatAty", {})
        end

        touser=User.find(params[:to_id])
        if touser.apple_chat_push
          content={}
          content_alert={}
          content_alert["alert"]="你有新的私信～"
          content["aps"]=content_alert

          req_params={}
          req_params.merge!({message: content.to_json,
                             message_type: 1,
                             account: "account"+params[:to_id].to_s})
          begin
            push_single_account(req_params)
          rescue Exception => e
            # push_single_account("1",0,content)
          end
        end


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
    u=User.find(params[:uid])

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

    tmp_unread=[]
    tmp_read=[]

    @msginfo.each do |t|
      unread=Unreadmsg.where("msgfrom_id=? and msgto_id=?", params[:uid], t["touser"]).first
      t["msg"]=Pmsg.where("(fromuser_id=? and touser_id=?) or (touser_id=? and fromuser_id=?)", t["touser"], params[:uid], t["touser"], params[:uid]).order("created_at desc")[0].msg
      t["randint"]=u.randint
      if !unread.nil?
        t["unreadnum"]=unread.msgunread
        t["updated_at"]=unread.updated_at
        if unread.msgunread==0
          tmp_read<<t
        else
          tmp_unread<<t
        end

      else
        t["unreadnum"]=0
        t["updated_at"]=Pmsg.where("(fromuser_id=? and touser_id=?) or (touser_id=? and fromuser_id=?)", t["touser"], params[:uid], t["touser"], params[:uid])[0].created_at
        tmp_read<<t
      end

    end
    tmp_unread=tmp_unread.sort_by { |t| t["updated_at"] }.reverse
    tmp_read=tmp_read.sort_by { |t| t["updated_at"] }.reverse

    @msginfo=tmp_unread|tmp_read

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

  def micropost_params
    params.require(:micropost).permit(:content, :user_id, :stock_id, :image)
  end

  def render_microposts_api_json(microposts, uid, my_reply_id)
    microposts_a=[]
    microposts.each do |m|
      tmp=m.attributes
      #评论数量
      tmp["comment_number"]=m.comments.where(visible: true).size
      #判断用户没有点赞
      if (!m.goods.find_by_id(uid).nil?)
        tmp["good"]="true"
      else
        tmp["good"]="false"
      end
      #点赞数量
      tmp["good_number"]=m.goods.size
      #判断股票名字
      if (!m.stock.nil?)
        tmp["stock_name"]=m.stock.name
        tmp["stock_full_name"]=m.stock.code+","+m.stock.name+","+m.stock.shortname
      else
        tmp["stock_name"]="无"
        tmp["stock_full_name"]="无"
      end

      #image名字
      tmp["image"]=m.image.to_s

      #判断未读
      if !my_reply_id.nil?
        unread=Replyrelationship.where("replyuser_id=? and replymicropost_id=?", uid, m.id)
        if unread.empty?
          tmp["unread"]=0
        else
          tmp["unread"]=unread[0].replyunread
        end
      else
        unread=Unreadrelation.where("unreaduser_id=? and unreadmicropost_id=?", uid, m.id)
        if unread.empty?
          tmp["unread"]=0
        else
          tmp["unread"]=unread[0].unread
        end
      end

      microposts_a.push(tmp)
    end

    result={}
    result["microposts"]=microposts_a
    result["unreadnum"]=Unreadmsg.where("msgfrom_id=?", uid).sum("msgunread")
    sum=0
    tmp_u=Unreadrelation.where("unreaduser_id=?", uid)
    tmp_u.each { |t| sum+=t.unread if !t.unreadmicropost.nil? && t.unreadmicropost.visible==true }
    result["unreadmicro"]=sum
    # result["unreadmicro"]=Unreadrelation.where("unreaduser_id=?", uid).sum("unread")
    sum=0
    tmp_r=Replyrelationship.where("replyuser_id=?", uid)
    tmp_r.each { |t| sum+=t.replyunread if !t.replymicropost.nil? && t.replymicropost.visible==true }
    result["unreplymicro"]=sum
    # result["unreplymicro"]=Replyrelationship.where("replyuser_id=?", uid).sum("replyunread")
    result["randint"]=User.find(uid).randint

    return result
  end
end


