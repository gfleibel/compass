# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  def create
    user = User.find_by(email: params[:user][:email])

    if user&.valid_password?(params[:user][:password])
      if user.confirmed?
        set_flash_message!(:notice, :signed_in)
        sign_in(user)
        yield user if block_given?
        respond_with user, location: after_sign_in_path_for(user)
      else
        flash[:alert] = "Antes de continuar, confirme a sua conta."
        redirect_to new_user_confirmation_path
      end
    else
      flash[:alert] = "Email ou senha inválidos."
      redirect_to new_user_session_path
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
