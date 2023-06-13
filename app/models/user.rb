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

  def validate_nsfw_content
    return unless photo.attached? # Assumindo que você tem um campo de avatar anexado

    # Obtenha a URL do avatar anexado
    image_url = photo.url

    # Execute a detecção de conteúdo NSFW
    nsfw_service = NsfwDetectionService.new(image_url)
    nsfw_result = nsfw_service.detect_nsfw_content

    # Verifique se o resultado indica conteúdo NSFW
    errors.add(:photo, 'contains NSFW content. Please upload a different image.') if nsfw_result == true
  end
end
