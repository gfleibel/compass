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
  end

  def resources
  end

  def conduct
  end
end
