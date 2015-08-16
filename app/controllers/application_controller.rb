class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  before_action :check_unread

  def fresh_when(opts = {})
    opts[:etag] ||= []
    # 保证 etag 参数是 Array 类型
    opts[:etag] = [opts[:etag]] unless opts[:etag].is_a?(Array)
    # 加入页面上直接调用的信息用于组合 etag
    opts[:etag] << current_user
    # Config 的某些信息
    # opts[:etag] << SiteConfig.custom_head_html
    # opts[:etag] << SiteConfig.footer_html
    # 加入通知数量
    # opts[:etag] << unread_notify_count
    # 加入flash，确保当页面刷新后flash不会再出现
    opts[:etag] << flash
    # 所有 etag 保持一天
    opts[:etag] << Date.current
    super(opts)
  end

  def check_unread
    if current_user.nil?
      @my_msg_unread=0
      @my_reply_unread=0
      @my_chat_unread=0
    else
      @my_msg_unread=current_user.unreadmicroposts.where('unread!=0 and visible=true').sum('unread')
      @my_reply_unread=current_user.replymicroposts.where('visible=true and replyunread!=0').sum('replyunread')
      @my_chat_unread=Unreadmsg.where("msgfrom_id=?",current_user.id).sum("msgunread")
    end
  end

  def push_single_account(req_params={})
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

  def push_all_devices(req_params={})
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
    sign = Digest::MD5.hexdigest("POSTopenapi.xg.qq.com/v2/push/all_device#{params_string}72371c5e43c99b8a4a845ff995bef03c")
    p.merge!({sign: sign})

    result=conn.post do |req|
      req.url '/v2/push/all_device'
      req.body = p
    end

    p result
  end

end
