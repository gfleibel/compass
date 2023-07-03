# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :user_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # # POST /resource
  def create
    @user = User.new(user_params)
    @user.mentor_transition_date.present? ? @user.mentor = true : @user.mentor = false
    @user.save
    UserMailer.confirmation_email(@user).deliver_later
    super
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute, programming_language: []])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute, programming_language: []])
  # end


  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
  # private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :country, :state, :city, :professional_field, :academic_degree, :mentor_current_employer, :mentor_transition_date, :github, :linkedin, :personal_site, :other_info, :mentor, programming_language: [])
  end
end
