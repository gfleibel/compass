class ContactMailer < ApplicationMailer
  def contact_email(name, email, message)
    @name = name
    @message = message
    @email = email
    mail(to: "compass.dev.br@gmail.com", subject: "Contato | #{name} - #{email}")
  end
end
