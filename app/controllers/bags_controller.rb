class BagsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_unless_authorized_delegate!
  before_action :set_bag, only: [:show, :edit, :update, :destroy]

  # GET /bags
  # GET /bags.json
  def index
    @bags = Bag.all
  end

  # GET /bags/1
  # GET /bags/1.json
  def show
  end

  # GET /bags/new
  def new
    @bag = Bag.new
  end

  # GET /bags/1/edit
  def edit
  end

  # POST /bags
  # POST /bags.json
  def create
    @bag = Bag.new(bag_params)

    respond_to do |format|
      if @bag.save
        format.html { redirect_to @bag, notice: 'Bag was successfully created.' }
        format.json { render :show, status: :created, location: @bag }
      else
        format.html { render :new }
        format.json { render json: @bag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bags/1
  # PATCH/PUT /bags/1.json
  def update
    respond_to do |format|
      if @bag.update(bag_params)
        format.html { redirect_to @bag, notice: 'Bag was successfully updated.' }
        format.json { render :show, status: :ok, location: @bag }
      else
        format.html { render :edit }
        format.json { render json: @bag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bags/1
  # DELETE /bags/1.json
  def destroy
    @bag.destroy
    respond_to do |format|
      format.html { redirect_to bags_url, notice: 'Bag was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bag
      @bag = Bag.includes(:hardwares).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bag_params
      params.require(:bag).permit(:name)
    end
end
