class UserMailer < ApplicationMailer
  def current_user
    user = User.find(params[:user][:mentee_id])
  end
  def welcome_mentor
    @user = User.find(params[:user][:mentor_id]) # Instance variable => available in view
    mail(to: @user.email, subject: 'Welcome to Le Wagon')
    # This will render a view in `app/views/user_mailer`!
  end
  def welcome_mentee
    @user = self.current_user
    mail(to: @user.email, subject: 'Welcome to Le Wagon')
    # This will render a view in `app/views/user_mailer`!
  end
end
