class Match < ApplicationRecord
  after_create :send_welcome_email

  belongs_to :mentor, class_name: 'User'
  belongs_to :mentee, class_name: 'User'

  validates :mentor_id, uniqueness: { scope: :mentee_id }

  private

  def send_welcome_email
    if self.mentor == true
      UserMailer.with(user: self).welcome_mentor.deliver_now
    else
      UserMailer.with(user: self).welcome_mentee.deliver_now
    end
  end
end
