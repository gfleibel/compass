class ContactMailer < ApplicationMailer
  def contact_email(name, email, message)
    @name = name
    @message = message
    @email = email
    mail(from: email, subject: "Contact Form Message #{name} - #{email}")
  end
end
