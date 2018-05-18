class PostsController < ApplicationController
  include PostsHelper
  before_action :authenticate_user!, except: [:home, :show]
  before_action :redirect_unless_comm!, except: [:home, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :enforce_real_post, only: [:show]

  def home
    base_query = Post.includes(:tags).all_posts.visible
    @featured_posts = base_query.featured.limit(2)
    @other_posts = base_query.where.not(id: [@featured_posts.map(&:id)]).page(params[:page])
    @upcoming_in_france = Competition.upcoming(3).in_france
    @major_champs = MajorComp.includes(:competition).all.order(:role)
  end

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.includes(:tags).all.order(id: :desc)
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save
      redirect_to view_post_path(@post), flash: { success: 'Post was successfully created.' }
    else
      render :new
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    if @post.update(post_params)
      redirect_to view_post_path(@post), flash: { success: 'Post was successfully updated.' }
    else
      render :edit
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    redirect_to news_index_path, flash: { success: 'Post was successfully destroyed.' }
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find_by_slug(params[:id]) || Post.find_by_id(params[:id])
    unless @post&.user_can_view?(current_user)
      raise ActiveRecord::RecordNotFound.new("Not Found")
    end
  end

  def enforce_real_post
    unless @post.real_post
      raise ActiveRecord::RecordNotFound.new("Not Found")
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params.require(:post).permit(:title, :body, :slug, :feature, :draft, :competition_page, :tags_string, :posted_at)
  end
end
