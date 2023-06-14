class UserAdminsController < ApplicationController
  def index
    @users = policy_scope(User)
    if current_user.admin?
      @users = User.all
      if params[:query].present?
        @users = @users.search_user(params[:query])
      end
    else
      redirect_to user_admins_path
    end
  end

  def show
    @user = User.find(params[:id])
    authorize @user
  end

  def destroy
    @user = User.find(params[:id])
    authorize @user
    @user.destroy
    redirect_to user_admins_path, status: :see_other
  end
end
