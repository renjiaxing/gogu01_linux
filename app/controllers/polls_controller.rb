class PollsController < ApplicationController
  before_action :set_poll, only: [:show, :edit, :update, :destroy]
  before_action :new_microposts,only: [ :index,:show,:my_index ]

  def index
    @polls = Poll.order("created_at desc").page(params[:page]).per(8)
  end

  def my_index
    @polls=current_user.polls.order("created_at desc").distinct.page(params[:page]).per(8)
    render 'index'
  end

  def new
    @poll = Poll.new
  end

  def create
    @poll = Poll.new(poll_params)
    if @poll.save
      flash[:success] = 'Poll was created!'
      redirect_to polls_path
    else
      render 'new'
    end
  end

  def show

  end

  def edit
  end

  def update
    if @poll.update_attributes(poll_params)
      flash[:success] = 'Poll was updated!'
      redirect_to polls_path
    else
      render 'edit'
    end
  end

  def destroy
    @poll = Poll.find_by_id(params[:id])
    if @poll.destroy
      flash[:success] = 'Poll was destroyed!'
    else
      flash[:warning] = 'Error destroying poll...'
    end
    redirect_to polls_path
  end

  private

  def poll_params
    params.require(:poll).permit(:topic, questions_attributes:
                                           [:id, :title, :_destroy, answers_attributes: [:id,:content,:_destroy]])
  end

  def set_poll
    @poll = Poll.find(params[:id])
  end

  def new_microposts
    @new_microposts=Micropost.where(visible: true).order("created_at desc").limit(6)
  end

end
