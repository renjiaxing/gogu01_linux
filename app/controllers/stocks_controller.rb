class StocksController < ApplicationController
  before_action :check_signed_in,except: [:stock_json]
  before_action :check_admin,only: [:show,:edit,:update,:destroy,:index,:create]
  before_action :set_stock, only: [:show, :edit, :update, :destroy]

  # GET /stocks
  # GET /stocks.json
  def index
    @stocks = Stock.all
    fresh_when(etag:[@stocks])
  end

  # GET /stocks/1
  # GET /stocks/1.json
  def show
  end

  # GET /stocks/new
  def new
    @stock = Stock.new
  end

  # GET /stocks/1/edit
  def edit
  end

  # POST /stocks
  # POST /stocks.json
  def create
    @stock = Stock.new(stock_params)

    respond_to do |format|
      if @stock.save
        format.html { redirect_to @stock, notice: 'Stock was successfully created.' }
        format.json { render :show, status: :created, location: @stock }
      else
        format.html { render :new }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stocks/1
  # PATCH/PUT /stocks/1.json
  def update
    respond_to do |format|
      if @stock.update(stock_params)
        format.html { redirect_to @stock, notice: 'Stock was successfully updated.' }
        format.json { render :show, status: :ok, location: @stock }
      else
        format.html { render :edit }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stocks/1
  # DELETE /stocks/1.json
  def destroy
    @stock.destroy
    respond_to do |format|
      format.html { redirect_to stocks_url, notice: 'Stock was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def choose_stock
    @stock = Stock.new
  end

  def show_stock_microposts
    @stock=Stock.find(params[:stock][:id])
    @microposts=@stock.microposts.order(updated_at: :desc).page(params[:page]).per(8)
    @new_microposts=Micropost.where(visible: true).order("created_at desc").limit(6)

    @item="stock"

    render 'users/show'
  end

  def stock_json
    if params[:code].include?(",")
      code=params[:code].split(",")[0]
    else
      code=params[:code]
    end
    @stocks=Stock.where("(code LIKE ?) OR (name LIKE ?) OR (shortname LIKE ?)","%"+code+"%","%"+code+"%","%"+code+"%").limit(params[:maxRows])
    render json: @stocks
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_stock
    @stock = Stock.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def stock_params
    params.require(:stock).permit(:code, :name)
  end

  def check_signed_in
    if !signed_in?
      flash[:alert] = "Please sign in to continue"
      redirect_to user_path(current_user)
    else
      @user = current_user
    end
  end

  def check_admin
    if !current_user.admin?
      redirect_to user_path(current_user)
    end
  end

end
