class MicropostsController < ApplicationController
  before_action :check_signed_in
  before_action :find_micropost,only: [:details]

  def new
    @micropost=current_user.microposts.build
  end

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to user_path(current_user)
    else
      render user_path(current_user)
    end
  end

  def details
    @comments=@micropost.comments.order(updated_at: :desc)
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content,:stock_id)
  end

  def find_micropost
    @micropost=Micropost.find(params[:id])
  end

  def check_signed_in
    if !signed_in?
      flash[:alert] = "Please sign in to continue"
      redirect_to user_path(current_user)
    else
      @user = current_user
    end
  end

end
