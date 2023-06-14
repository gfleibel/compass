class User < ApplicationRecord
  after_commit :validate_nsfw_content, if: -> { photo.attached? && !@file_processed }
  # after_update :validate_nsfw_content
  has_one_attached :photo

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :mentor_matches, class_name: 'Match', foreign_key: 'mentor_id', dependent: :destroy
  has_many :mentee_matches, class_name: 'Match', foreign_key: 'mentee_id', dependent: :destroy

  validates :first_name, :last_name, :email, :country, :city, :state, :professional_field, :academic_degree, presence: true
  validates :github, format: { with: /\A[A-Za-z0-9]+\z/ }, uniqueness: true, allow_blank: true
  validates :linkedin, format: { with: /https:\/\/www\.linkedin\.com\/in\/.*/ }, uniqueness: true, allow_blank: true

  include CloudinaryHelper

  def validate_nsfw_content
    @file_processed = true
    return unless photo.attached?

    image_url = photo.url
    nsfw_service = NsfwDetectionService.new(image_url)
    nsfw_result = nsfw_service.detect_nsfw_content
    photo.purge if nsfw_result == true
  end
end
