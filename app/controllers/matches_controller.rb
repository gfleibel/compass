class MatchesController < ApplicationController
  before_action :set_match, only: %i[show edit update destroy]
  def index
    @user = current_user
    if @user.mentor?
      @matches = Match.where(mentor_id: @user.id)
    else
      @matches = Match.where(mentee_id: @user.id)
    end
  end

  def show
    @match = policy_scope(Match).find(params[:id])
  end

  def new
    @match = Match.new
    authorize @match
  end

  def create
    @match = Match.new(match_params)
    @match.matched = false
    if @match.save
      redirect_to match_path(@match)
    else
      render :new, status: :unprocessable_entity
    end
    authorize @match
  end

  def destroy
    authorize @match
    @match.destroy
    redirect_to users_path, notice: 'Mentoria removida com sucesso.', status: :see_other
  end

  private

  def match_params
    params.require(:match).permit!
  end

  def set_match
    Match.find(params[:id])
  end
end
