class User < ActiveRecord::Base
  #This takes care of authentication and verification
  has_secure_password

  #Downcase Email before saving,Just in case
  before_save { self.email = email.downcase }

  before_create { generate_remember_token(:remember_token) }

  #Regular Expression to validate Email
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  #Change these as per your requirement
  validates :name,length: { maximum: 100 }
  validates :email, presence: true, format: { with: EMAIL_REGEX },
            uniqueness: true, length: { minimum: 6 }
  # validates :phone, length: { maximum: 15 },numericality: { only_integer: true }
  validates :password, length: { minimum: 6 }

  has_many :microposts,dependent: :destroy

  has_many :mystocks

  has_many :comments

  has_many :goodrelations,foreign_key: "good_id"
  has_many :begoods, through: :goodrelations,source: :begood

  has_many :anons,foreign_key: "anonuser_id"
  has_many :anonmicroposts,through: :anons,source: :anonmicropost

  has_many :pmsgs,foreign_key: "fromuser_id"
  has_many :tousers,through: :pmsgs,source: :touser

  has_many :unreadrelations,foreign_key: "unreaduser_id"
  has_many :unreadmicroposts,through: :unreadrelations,source: :unreadmicropost

  has_many :unreadmsgs,foreign_key: "msgfrom_id"
  has_many :msgtos,through: :unreadmsgs,source: :msgto

  has_many :replyrelationships,foreign_key: "replyuser_id"
  has_many :replymicroposts,through: :replyrelationships,source: :replymicropost

  has_many :votes ,dependent: :destroy
  has_many :answers,through: :votes
  has_many :questions,through: :votes
  has_many :polls,through: :votes

  def self.authenticate_user(email, password)
    user = find_by_email(email)
    if user && user.authenticate(password)
      user
    else
      nil
    end
  end

  #Generate a base64 token using SecureRandom.urlsafe_base64 and update the time the email is sent.
  #Since we will be implementing password reset we can use the same fields for confirmation too.
  #:password_reset_token and :password_sent_at
  def send_confirmation
    self.update_column(:password_reset_token, SecureRandom.urlsafe_base64)
    self.update_column(:password_sent_at, Time.zone.now)
    UserMailer.send_confirmation_mail(self).deliver
  end

  def send_password_reset
    self.update_column(:password_reset_token, SecureRandom.urlsafe_base64)
    self.update_column(:password_sent_at, Time.zone.now)
    UserMailer.send_password_reset_mail(self).deliver
  end

  def generate_remember_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def voted_for?(poll)
    questions.distinct.any? {|v| v.poll == poll }
  end


  def umeng_android_push_send(ticker_title,title,text,send_type,alias_type,alias_name,open,activity,extra)
    appkey = '55bb222767e58ea1020021a4'
    app_master_secret = 'geywoqplclq2n53gynvaau32zrcbwpni'
    timestamp = Time.now.to_i
    method = 'POST'
    url = 'http://msg.umeng.com/api/send'
    tmp={}
    tmp["appkey"]=appkey
    tmp["timestamp"]=timestamp
    tmp["type"]=send_type
    if send_type=="customizedcast"
      tmp["alias"]=alias_name
      tmp["alias_type"]=alias_type
    end
    body={}
    body["ticker"]=ticker_title
    body["title"]=title
    body["text"]=text
    body["after_open"]=open
    payload={}
    payload["body"]=body
    if open=="go_activity"
      body["activity"]=activity
      payload["extra"]=extra
    end
    payload["display_type"]="notification"
    tmp["payload"]=payload

    post_body=tmp.to_json

    sign=Digest::MD5.hexdigest([method, url, post_body, app_master_secret].join)

    conn = Faraday.new(:url => 'http://msg.umeng.com') do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end

    resp=conn.post do |req|
      req.url '/api/send?sign='+sign
      req.headers['Content-Type'] = 'application/json'
      req.body = post_body
    end

    p post_body

    return resp.body

  end
end
