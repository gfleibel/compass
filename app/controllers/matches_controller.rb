class MatchesController < ApplicationController
  before_action :set_match, only: %i[show edit update destroy]
  def index
    @user = policy_scope(User)
    @user = current_user
    if @user.mentor?
      all_matches = Match.where(mentor_id: @user.id)
    else
      all_matches = Match.where(mentee_id: @user.id)
    end
    @matches = all_matches.where(matched: true)
    @pending_matches = all_matches.where(matched: false)
  end

  def show
    @match = policy_scope(Match).find(params[:id])
    authorize @match
  end

  def new
    @match = Match.new
    authorize @match
  end

  def create
    @match = Match.new
    @match.matched = false
    @match.mentor_id = params[:profile_id]
    @match.mentee_id = current_user.id
    authorize @match
    if @match.save
      redirect_to profile_matches_path(@match), notice: 'Solicitação de mentoria criada com sucesso.'
    else
      redirect_to profile_matches_path(@match), alert: 'Erro na solicitação de mentoria.'
    end
  end

  def destroy
    authorize @match
    @match.destroy
    redirect_to users_path, notice: 'Mentoria removida com sucesso.', status: :see_other
  end

  private

  def match_params
    params.require(:match).permit(:mentor_id, :mentee_id, :matched)
  end

  def set_match
    Match.find(params[:id])
  end
end
