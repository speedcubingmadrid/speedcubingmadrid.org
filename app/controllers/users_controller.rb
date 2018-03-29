class UsersController < ApplicationController
  #FIXME
  before_action :authenticate_user!, except: [:home]
  before_action :redirect_unless_admin!, except: [:edit, :update]

  def edit
    @user = user_to_edit
    return if redirect_if_cannot_edit_user(@user)
  end

  def update
  end

  def home
  end

  def user_to_edit
    User.find(params[:id] || current_user.id)
  end

  def redirect_if_cannot_edit_user(user)
    unless current_user&.can_edit_user?(user)
      flash[:danger] = "Vous ne pouvez pas éditer cet utilisateur"
      redirect_to root_url
      return true
    end
    false
  end

  private :user_to_edit, :redirect_if_cannot_edit_user
end
