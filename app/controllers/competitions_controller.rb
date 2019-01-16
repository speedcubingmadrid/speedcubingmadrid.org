class CompetitionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :old_competitions_list, :show_competition_page]
  # For now this controller is accessible to anyone with the scope, as the actual check is done on the WCA part.
  before_action :redirect_unless_has_manage_competition_scope!, only: [:show_registrations, :my_competitions]
  before_action :redirect_unless_comm!, except: [:show_registrations, :my_competitions, :index, :old_competitions_list, :show_competition_page]

  def old_competitions_list
    @competition_pages = Post.competition_pages.visible
  end

  def show_competition_page
    @competition = Post.find_by_slug(params[:slug])
    unless @competition&.user_can_view?(current_user) && @competition&.competition_page
      raise ActiveRecord::RecordNotFound.new("Not Found")
    end
  end

  def index
    respond_to do |format|
      format.html
      format.ics do
        # Try prevent caching for this page
        response.headers["Cache-Control"] = "no-cache, no-store"
        response.headers["Pragma"] = "no-cache"
        response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
        @events = CalendarEvent.visible
        @competitions = []
        begin
          # Only show future competitions
          comps_response = RestClient.get(wca_api_competitions_url, params: { country_iso2: "ES", start: 2.days.ago})
          @competitions = JSON.parse(comps_response.body)
        rescue => err
          # We actually don't care about the error
        end
      end
    end
  end

  def manage_big_champs
    @champs = MajorComp.all
  end

  def update_big_champs
    @champs = MajorComp.all
    big_champs = big_champs_params
    roles = big_champs.keys
    status = true
    roles.each do |r|
      puts "doing #{r}"
      mc = @champs.find { |c| c.role == r }
      raise ActiveRecord::RecordNotFound unless mc
      attributes = big_champs[r]
      success = mc.update(attributes)
      status = status && success
    end
    if status
      redirect_to root_path
    else
      render :manage_big_champs
    end
  end

  def show_registrations
    comp_id = params.require(:competition_id)
    @competition = nil
    @persons = { pending: [], accepted: [], deleted: [], not_registered: [] }
    @error = nil
    begin
      comp_response = RestClient.get(wca_api_competition_wcif_url(comp_id), { Authorization: "Bearer #{session[:access_token]}" })
      @competition = JSON.parse(comp_response.body)
    rescue => err
      @error = err
    end
    if @competition
      subscribers = Subscription.active.includes(:user)
      @subscribers_by_name = subscribers.map { |s| "#{s.name.downcase}" }
      @subscribers_by_id = subscribers.map { |s| s.wca_id }.reject(&:blank?)
      @persons.merge!(@competition["persons"].group_by do |p|
        if p["registration"]
          p["registration"]["status"].to_sym
        else
          :not_registered
        end
      end)
    end
  end

  def my_competitions
    @my_competitions = []
    @error = nil
    begin
      comps_response = RestClient.get(wca_api_competitions_url, { Authorization: "Bearer #{session[:access_token]}", params: { managed_by_me: true, start: 2.days.ago.to_date} })
      @my_competitions = JSON.parse(comps_response.body)
    rescue RestClient::ExceptionWithResponse => err
      @error = err
    end
  end

  def redirect_unless_has_manage_competition_scope!
    unless has_manage_competitions_scope
      redirect_to root_url, flash: { warning: "No has permitido que la AMS administre tus competiciones." }
    end
  end

  def big_champs_params
    champ_params = [:competition_id, :name, :alt_text]
    params.require(:big_champs).permit(spanish: champ_params, euro: champ_params, world: champ_params)
  end

  private :redirect_unless_authorized_delegate!, :big_champs_params
end
