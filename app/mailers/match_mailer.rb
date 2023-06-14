class MatchMailer < ApplicationMailer
  def match_email_mentee(name, email, message)
    @name = @user.name
    @email = @user.email
    mail(to: email, subject: "Solicitação de Mentoria")
  end
end
