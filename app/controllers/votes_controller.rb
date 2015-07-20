class VotesController < ApplicationController
  def create
    @poll = Poll.find_by_id(params[:poll][:id])
    if current_user && params[:poll] && params[:poll][:id] && params[:answer]
      changed=1
      @poll.questions.each do |q|
        @option=q.answers.find_by_id(params[:answer][q.id.to_s])
        if @option && @poll && !current_user.voted_for?(@poll)
          @option.votes.create({user_id: current_user.id,question_id:q.id,poll_id:@poll.id})
          @poll.votenum=@poll.questions[0].votes_summary
          @poll.save
        else
          # render js: 'alert(\'Your vote cannot be saved. Have you already voted?\');'
          changed=0
        end
      end
      if changed==1
        redirect_to polls_path
      else
        redirect_to poll_path(@poll)
      end
    else
      flash[:alert]="你有答案未选择~"
      redirect_to poll_path(@poll)
      # render js: 'alert(\'Your vote cannot be saved.\');'
    end
  end
end