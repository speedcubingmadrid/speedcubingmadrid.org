class CompetitionsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_unless_has_manage_competition_scope!

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
      @subscribers_by_name = subscribers.map { |s| "#{s.firstname.downcase} #{s.name.downcase}" }
      @subscribers_by_id = subscribers.map { |s| s.wca_id }.reject!(&:blank?)
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
      #FIXME: restore correct start date
      comps_response = RestClient.get(wca_api_competitions_url, { Authorization: "Bearer #{session[:access_token]}", params: { managed_by_me: true, start: 1.month.ago} })
      @my_competitions = JSON.parse(comps_response.body)
    rescue RestClient::ExceptionWithResponse => err
      @error = err
    end
  end

  def redirect_unless_has_manage_competition_scope!
    unless has_manage_competitions_scope
      redirect_to root_url, flash: { warning: "Vous n'avez pas autorisé l'AFS à gérer vos compétitions." }
    end
  end

  private :redirect_unless_authorized_delegate!
end
