class UserAdminsController < ApplicationController
  before_action :fetch_and_authorize_user, only: %i[show destroy]

  def index
    @users = policy_scope(User)
    return redirect_to user_admins_path unless current_user.admin?

    @users = User.all
    @users = @users.search_user(params[:query]) if params[:query].present?
  end

  def show; end

  def destroy
    @user.destroy
    redirect_to user_admins_path, status: :see_other
  end

  private

  def fetch_and_authorize_user
    @user = User.find(params[:id])
    authorize @user
  end
end
