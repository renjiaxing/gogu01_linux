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
      redirect_to pmsgs_path
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
