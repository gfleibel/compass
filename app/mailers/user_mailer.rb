class UserMailer < ApplicationMailer
  def current_user
    User.find(params[:user])
  end
  def welcome_mentor
    @mentee = User.find(params[:mentee])
    @user = User.find(params[:user]) # Instance variable => available in view
    mail(to: @user.email, subject: 'Compass | Solicitação de Mentoria')
    # This will render a view in `app/views/user_mailer`!
  end
  def welcome_mentee
    @mentor = User.find(params[:mentor])
    @user = self.current_user
    mail(to: @user.email, subject: 'Compass | Confirmação de solicitação de mentoria')
    # This will render a view in `app/views/user_mailer`!
  end
end
