class CompetitionGalleriesController < ApplicationController
  include CompetitionGalleriesHelper
  before_action :authenticate_user!, except: [:index, :show]
  before_action :redirect_unless_comm!, except: [:index, :show]

  def admin
    @competition_galleries = CompetitionGallery.all.order(created_at: :desc)
  end

  def index
    @featured_competition_galleries = CompetitionGallery.visible.featured.order(created_at: :desc)
    @other_competition_galleries = CompetitionGallery.visible.not_featured.order(created_at: :desc)
  end

  def new
    @competition_gallery = CompetitionGallery.new
  end

  def edit
    @competition_gallery = competition_gallery_from_params
  end

  def update
    @competition_gallery = competition_gallery_from_params

    if @competition_gallery.update_attributes(competition_gallery_params)
      flash[:success] = "¡Galería actualizada con éxito!"
      redirect_to edit_competition_gallery_path(@competition_gallery)
    else
      render :edit
    end
  end

  def create
    @competition_gallery = CompetitionGallery.new(competition_gallery_params)
    @competition_gallery.user = current_user

    if @competition_gallery.save
      flash[:success] = "¡Galería creada con éxito!"
      redirect_to edit_competition_gallery_path(@competition_gallery)
    else
      @competition_gallery.errors[:name].concat(@competition_gallery.errors[:id])
      render :new
    end
  end

  def show
    @competition_gallery = competition_gallery_from_params
    @competition_name = Competition.find(@competition_gallery.competition_id).name
  end

  def destroy
    @competition_gallery = competition_gallery_from_params

    @competition_gallery.photos.purge
    @competition_gallery.destroy
    redirect_to admin_competition_galleries_path, flash: { success: 'La galería se ha borrado con éxito.' }
  end

  def delete_photo
    @photo = ActiveStorage::Attachment.find(params[:id])
    @photo.purge
    flash[:success] = "La foto se ha borrado con éxito."
    redirect_back(fallback_location: request.referer)
  end

  private def competition_gallery_params
    params.require(:competition_gallery).permit(:competition_id, :user_id, :draft, :feature, photos: [])
  end

  private def competition_gallery_from_params
    CompetitionGallery.find(params[:id])
  end
end
