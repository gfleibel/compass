class MatchesController < ApplicationController
  before_action :set_match, only: %i[show edit update destroy]

  def index
    @user = policy_scope(User)
    @user = current_user

    where_match_type = @user.mentor? ? { mentor: @user } : { mentee: @user }
    all_matches = Match.where(**where_match_type)

    @matches = all_matches.where(matched: true)
    @pending_matches = all_matches.where(matched: false)
    asyn_update
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
    return redirect_to profile_matches_path(@match), notice: 'Solicitação de mentoria criada com sucesso.' if @match.save

    redirect_to profile_matches_path(@match), alert: 'Erro na solicitação de mentoria.'
  end

  def update
    authorize @match
    @match.update(match_params)
    @chatroom = Chatroom.create(match: @match)
    deliver_mail
    redirect_to profile_matches_path(@match)
  end

  def destroy
    @user = policy_scope(User)
    @user = current_user
    authorize @match
    @match.destroy
    redirect_to profile_path(@user), status: :see_other
  end

  private

  def match_params
    params.require(:match).permit(:mentor_id, :mentee_id, :matched)
  end

  def set_match
    @match = Match.find(params[:id])
  end

  def asyn_update
    @pending_matches.each{ |match| MatchTimeJob.perform_now(match) }
  end

  def deliver_mail
    UserMailer.with(user: @match.mentor_id, mentee: @match.mentee_id).confirmation_mentor.deliver_later
    UserMailer.with(user: @match.mentee_id, mentor: @match.mentor_id).confirmation_mentee.deliver_later
  end
end
