class User < ApplicationRecord
  validate :validate_nsfw_content
  has_one_attached :photo

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :mentor_matches, class_name: 'Match', foreign_key: 'mentor_id', dependent: :destroy
  has_many :mentee_matches, class_name: 'Match', foreign_key: 'mentee_id', dependent: :destroy

  validates :first_name, :last_name, :email, :country, :city, :state, :professional_field, :academic_degree, presence: true
  validates :github, format: { with: /\A[A-Za-z0-9]+\z/ }, uniqueness: true, allow_blank: true
  validates :linkedin, format: { with: /https:\/\/www\.linkedin\.com\/in\/.*/ }, uniqueness: true, allow_blank: true

  include CloudinaryHelper

  include PgSearch::Model

  pg_search_scope :search_user,
    against: %i[first_name last_name id email],
    using: {
      tsearch: { prefix: true }
    }
  def validate_nsfw_content
    return unless photo.attached?
    image_url = cloudinary_url(photo.key)
    nsfw_service = NsfwDetectionService.new(image_url)
    nsfw_result = nsfw_service.detect_nsfw_content

    errors.add(:photo, 'A foto contém conteúdo explícito/sensível. Por favor, faça o upload de uma imagem diferente.') if nsfw_result == true
  end
end
