class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home contact resources conduct about]

  def home; end

  def contact; end

  def about; end

  def contact_submit
    response = verify_recaptcha

    if response['success']
      send_form_via_email
      redirect_to root_path
    else
      flash[:error] = "Erro na validação do reCAPTCHA"
      redirect_to contact_path
    end
  end

  def resources; end

  def conduct; end

  private

  def verify_recaptcha
    recaptcha_response = params['g-recaptcha-response']
    recaptcha_secret_key = ENV['RECAPTCHA_PRIVATE_KEY']

    recaptcha_verification_url = "https://www.google.com/recaptcha/api/siteverify"
    HTTParty.post(recaptcha_verification_url, body: { secret: recaptcha_secret_key, response: recaptcha_response })
  end

  def send_form_via_email
    mail = ContactMailer.with(name: params[:name], email: params[:email], message: params[:message])
                        .contact_email(params[:name], params[:email], params[:message])
    mail.deliver_later
  end
end
