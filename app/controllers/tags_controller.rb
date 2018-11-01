class TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_unless_comm!
  before_action :set_tag, only: [:edit, :update]

  # GET /tags
  def index
    @tags = Tag.all
  end

  # GET /tags/1/edit
  def edit
  end

  # PATCH/PUT /tags/1
  def update
    if @tag.update(tag_params)
      redirect_to tags_path, flash: { success: 'Etiqueta actualizada.' }
    else
      render :edit
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_tag
    @tag = Tag.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tag_params
    params.require(:tag).permit(:fullname, :color)
  end
end
