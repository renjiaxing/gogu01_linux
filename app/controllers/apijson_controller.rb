class ApijsonController < ApplicationController
  before_action :checktoken, except: [:login_json, :login_token_json, :reg_json]

  def microposts_json

    if params[:stock_id].nil? and params[:my_id].nil?
      @microposts=Micropost.order("created_at desc").limit(6)
    elsif !params[:stock_id].nil? and params[:my_id].nil?
      @microposts=Micropost.where("stock_id=?", params[:stock_id]).order("created_at desc").limit(6)
    elsif params[:stock_id].nil? and !params[:my_id].nil?
      user=User.find(params[:my_id])
      @microposts=user.microposts.order("created_at desc").limit(6)
    end
    @microposts_a=[]
    @microposts.each do |m|
      tmp=m.attributes
      tmp["comment_number"]=m.comments.size
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
      @microposts_a.push(tmp)
    end
    render json: @microposts_a
  end

  def down_microposts_json
    if params[:stock_id].nil? and params[:my_id].nil?
      @microposts=Micropost.where("id < ?", params[:down]).order("created_at desc").limit(6)
    elsif !params[:stock_id].nil? and params[:my_id].nil?
      @microposts=Micropost.where("stock_id=? AND id < ?", params[:stock_id], params[:down]).order("created_at desc").limit(6)
    elsif params[:stock_id].nil? and !params[:my_id].nil?
      user=User.find(params[:my_id])
      @microposts=user.microposts.where("id < ?", params[:down]).order("created_at desc").limit(6)
    end
    @microposts_a=[]
    @microposts.each do |m|
      tmp=m.attributes
      tmp["comment_number"]=m.comments.size
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
      @microposts_a.push(tmp)
    end
    render json: @microposts_a
  end

  def up_microposts_json
    if params[:stock_id].nil? and params[:my_id].nil?
      @microposts=Micropost.where("id > ?", params[:up]).order("created_at").limit(6)
    elsif !params[:stock_id].nil? and params[:my_id].nil?
      @microposts=Micropost.where("stock_id=? AND id > ?", params[:stock_id], params[:up]).order("created_at").limit(6)
    elsif params[:stock_id].nil? and !params[:my_id].nil?
      user=User.find(params[:my_id])
      @microposts=user.microposts.where("id > ?", params[:up]).order("created_at desc").limit(6)
    end
    @microposts_a=[]
    @microposts.each do |m|
      tmp=m.attributes
      tmp["comment_number"]=m.comments.size
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
      @microposts_a.push(tmp)
    end
    render json: @microposts_a
  end

  def detail_micropost_json
    @micropost=Micropost.find(params[:mid])
    @comments=@micropost.comments.order(updated_at: :desc)
    @micropost.comments=@comments
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

  def new_comment_json
    @micropost=Micropost.find(params[:mid])
    user=User.find(params[:uid])
    comment=@micropost.comments.create(msg: params[:msg])
    comment.user=user
    @resp={}
    if comment.save
      if user!=@micropost.user
        @unread=Unreadrelation.find_by(unreaduser_id: @micropost.user.id, unreadmicropost_id: @micropost.id)
        if (@unread.nil?)
          @unread=Unreadrelation.create(unreaduser_id: @micropost.user.id, unreadmicropost_id: @micropost.id, unread: 0)
        end
        @unread.unread+=1
        @unread.save
      end
      @resp["result"]="ok"
      @resp["comments"]=Micropost.find(params[:mid]).comments
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

  def micropost_nogood_json
    user=User.find(params[:uid])
    micropost=Micropost.find(params[:mid])
    user.begoods.delete(micropost)
    @resp={}
    @resp["result"]="ok"
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