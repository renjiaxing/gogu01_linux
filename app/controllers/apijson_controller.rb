class ApijsonController < ApplicationController

  def microposts_json
    @microposts=Micropost.order("created_at desc").limit(6);
    render json:@microposts
  end

  def down_microposts_json
    @microposts=Micropost.where("id < ?",params[:down]).order("created_at desc").limit(6)
    render json:@microposts
  end

  def up_microposts_json
    @microposts=Micropost.where("id > ?",params[:up]).order("created_at").limit(6)
    render json:@microposts
  end

  def new_micropost_json
    user=User.find(params[:user_id]);
    @micropost = user.microposts.new
    @micropost.content=params[:content]
    @resp={}
    if @micropost.save
      @resp["result"]="true"
    else
      @resp["result"]="false"
    end
    render json:@resp
  end

end