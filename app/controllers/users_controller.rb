class UsersController < ApplicationController
  # FIXME: home should be in a different controller
  before_action :authenticate_user!, except: [:home]
  before_action :redirect_unless_admin!, except: [:home, :edit, :update]
  before_action :set_and_redirect_if_cannot_edit_user, only: [:edit, :update]

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Utilisateur mis à jour avec succès"
      redirect_to edit_user_path(@user)
    else
      render :edit
    end
  end

  def home
  end

  def user_to_edit
    User.find(params[:id] || current_user.id)
  end

  def set_user!
    @user = user_to_edit
  end

  def set_and_redirect_if_cannot_edit_user
    set_user!
    unless current_user&.can_edit_user?(@user)
      flash[:danger] = "Vous ne pouvez pas éditer cet utilisateur"
      redirect_to root_url
    end
  end

  def user_params
    permitted_params = []
    if current_user.admin?
      permitted_params += [
        :admin,
        :communication,
        :french_delegate,
      ]
    end
    params.require(:user).permit(*permitted_params)
  end

  private :user_to_edit, :set_and_redirect_if_cannot_edit_user, :set_user!, :user_params
end
