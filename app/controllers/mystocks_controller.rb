class MystocksController < ApplicationController
  before_action :set_mystock, only: [:show, :edit, :update, :destroy]

  # GET /mystocks
  # GET /mystocks.json
  def index
    @mystocks = initialize_grid(Mystock)
  end

  # GET /mystocks/1
  # GET /mystocks/1.json
  def show
  end

  # GET /mystocks/new
  def new
    @mystock = Mystock.new
  end

  # GET /mystocks/1/edit
  def edit
  end

  # POST /mystocks
  # POST /mystocks.json
  def create
    @mystock = Mystock.new(mystock_params)

    @existmystock=Mystock.find_by(stock_id:params[:mystock][:stock_id])

    respond_to do |format|
      if !@existmystock.nil?
        format.html { redirect_to new_mystock_path, notice: '您已经关注该股票～' }
      elsif @mystock.save
        format.html { redirect_to mystocks_path, notice: 'mystock was successfully created.' }
        format.json { render :show, status: :created, location: @mystock }
      else
        format.html { render :new }
        format.json { render json: @mystock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mystocks/1
  # PATCH/PUT /mystocks/1.json
  def update
    respond_to do |format|
      if @mystock.update(mystock_params)
        format.html { redirect_to @mystock, notice: 'mystock was successfully updated.' }
        format.json { render :show, status: :ok, location: @mystock }
      else
        format.html { render :edit }
        format.json { render json: @mystock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mystocks/1
  # DELETE /mystocks/1.json
  def destroy
    @mystock.destroy
    respond_to do |format|
      format.html { redirect_to mystocks_path, notice: 'mystock was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_mystock
    @mystock = Mystock.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def mystock_params
    params.require(:mystock).permit(:user_id,:stock_id)
  end
end
