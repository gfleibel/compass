class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home contact resources conduct]
  def home
  end

  def contact
  end

  def contact_submit
    mail = ContactMailer.with(name: params[:name], email: params[:email], message: params[:message]).contact_email(params[:name], params[:email], params[:message])
    mail.deliver_now
    redirect_to root_path

    # Verificar o reCAPTCHA
    recaptcha_response = params['g-recaptcha-response']
    recaptcha_secret_key = RECAPTCHA_PRIVATE_KEY

    recaptcha_verification_url = "https://www.google.com/recaptcha/api/siteverify"
    response = HTTParty.post(recaptcha_verification_url, body: { secret: recaptcha_secret_key, response: recaptcha_response })

    if response['success']
      # O reCAPTCHA foi validado com sucesso, continue com o envio do formulário
      mail = ContactMailer.with(name: params[:name], email: params[:email], message: params[:message]).contact_email(params[:name], params[:email], params[:message])
      mail.deliver_now
      redirect_to root_path
    else
      # O reCAPTCHA falhou, lide com o erro
      flash[:error] = "Erro na validação do reCAPTCHA"
      redirect_to your_contact_form_path
    end
  end

  def resources
  end

  def conduct
  end
end
