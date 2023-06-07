class ContactMailer < ApplicationMailer
  def contact_email(name, email, message)
    @name = name
    @message = message
    @email = email
    mail(to: "no.reply.compass.app@gmail.com", subject: "Contato | #{name} - #{email}")
  end
end
