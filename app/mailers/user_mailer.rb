class UserMailer < ApplicationMailer
  def current_user
    User.find(params[:user][:mentee_id])
  end
  def welcome_mentor
    @mentor = User.find(:user) # Instance variable => available in view
    mail(to: "vitoria.vital123@gmail.com", subject: 'Welcome to Le Wagon')
    # This will render a view in `app/views/user_mailer`!
  end
  def welcome_mentee
    @user = self.current_user
    mail(to: @user.email, subject: 'Compass | Confirmação de solicitação de mentoria')
    # This will render a view in `app/views/user_mailer`!
  end
end
