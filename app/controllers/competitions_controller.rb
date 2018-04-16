class CompetitionsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_unless_authorized_delegate!

  def my_competitions
    @my_competitions = []
    @error = nil
    begin
      comps_response = RestClient.get(wca_api_competitions_url, { Authorization: "Bearer #{session[:access_token]}", params: { managed_by_me: true, start: 1.month.ago} })
      @my_competitions = JSON.parse(comps_response.body)
    rescue RestClient::ExceptionWithResponse => err
      @error = err
    end
  end
end
