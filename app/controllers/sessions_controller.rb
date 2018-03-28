class SessionsController < ApplicationController
  def new
    scopes = "public email dob"
    redirect_to wca_login_url(scopes)
  end

  # The WCA.org OAuth code redirects to here after user logs in
  # From here: https://github.com/larspetrus/Birdflu/blob/1a74b55c1005e3ad74c51881c06b88a9d3f3f8d7/app/controllers/oauth_controller.rb
  def create
    token_params = {
      code: params[:code],
      grant_type: 'authorization_code',
      redirect_uri: wca_callback_url,
      client_id: wca_client_id,
      client_secret: wca_client_secret,
    }
    begin
      token_response = RestClient.post(wca_token_url, token_params)
    rescue RestClient::ExceptionWithResponse => err
      return fail_and_redirect(err.response.code)
    end

    access_token = JSON.parse(token_response.body)["access_token"]

    begin
      me_response = RestClient.get(wca_api_url("/me"), { Authorization: "Bearer #{access_token}" })
    rescue RestClient::ExceptionWithResponse => err
      return fail_and_redirect(err.response.code)
    end

    me_data = JSON.parse(me_response.body)["me"]

    status, user = User.create_or_update(me_data)
    unless status
      return fail_and_redirect("Impossible de créer l'utilisateur! (C'est une erreur sérieuse :( !)")
    end
    session[:user_id] = user.id
    session[:access_token] = access_token

    Rails.logger.info "WCA Logged in as '#{me_data['name']}'."
    redirect_to root_url, flash: { success: 'Vous êtes connecté !' }
  end

  def destroy
    reset_session
    redirect_to root_url, flash: { success: 'Vous avez été déconnecté !' }
  end

  private
  def fail_and_redirect(message)
      reset_session
      Rails.logger.info "WCA Login failed."
      redirect_to(root_url, alert: "Impossible de se connecter ! Erreur : #{message}")
  end
end
