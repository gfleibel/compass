class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_one_attached :photo

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :mentor_matches, class_name: 'Match', foreign_key: 'mentor_id', dependent: :destroy
  has_many :mentee_matches, class_name: 'Match', foreign_key: 'mentee_id', dependent: :destroy

  validates :first_name, :last_name, :email, :country, :city, :state, :professional_field, :academic_degree, presence: true
end
