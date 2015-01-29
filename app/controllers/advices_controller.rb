class AdvicesController < ApplicationController

  def new
    @advice=Advice.new
  end

  def create
    @advice=Advice.new(advice_params)

    respond_to do |format|
      if @advice.save
        format.html { redirect_to user_path(current_user), notice: 'Test was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def index
    @grid_advices=initialize_grid(Advice)
  end

  def show
  end

  def destroy

  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_advice
    @advice = Advice.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def advice_params
    params.require(:advice).permit(:title,:content)
  end
end
