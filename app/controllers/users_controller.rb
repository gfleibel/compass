class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  def index
    @users = policy_scope(User)
    if params[:mentor] == true
      @mentees = @users.where(mentor: false)
    else
      @mentors = @users.where(mentor: true)
    end
  end

  def show
    @user = policy_scope(User).find(params[:id])
  end

  def edit
    authorize @user
  end

  def update
    authorize @user
    @user.update(user_params)
    redirect_to user_path(@user)
  end

  def new
    @user = User.new
    authorize @user
  end

  def create
    @user = User.create(user_params)
    if @user.save
      redirect_to user_path(@user)
    else
      render :new, status: :unprocessable_entity
    end
    authorize @user
  end

  def destroy
    authorize @user
    @user.destroy
    redirect_to root_path, notice: 'Usuário removido com sucesso.', status: :see_other
  end

  private

  def user_params
    params.require(:user).permit!
  end

  def set_user
    User.find(params[:id])
  end
end
