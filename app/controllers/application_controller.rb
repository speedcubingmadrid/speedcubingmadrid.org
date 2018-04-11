class ApplicationController < ActionController::Base
  include ApplicationHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user
    begin
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    rescue Exception => e
      nil
    end
  end

  def authenticate_user!
    if !current_user
      session[:return_to] ||= request.original_url
      redirect_to signin_url
    end
  end

  def redirect_unless_admin!
    unless current_user&.admin?
      redirect_to root_url, :alert => 'Seuls les administrateurs ont accès à cette page.'
    end
  end

  def redirect_unless_authorized_delegate!
    #FIXME
    unless true
      #unless current_user.delegate?
      redirect_to root_url, :alert => 'Seuls les délégués ont accès à cette page.'
    end
  end

  private :current_user, :authenticate_user!, :redirect_unless_admin!, :redirect_unless_authorized_delegate!
end
