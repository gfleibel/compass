class User < ApplicationRecord
  after_commit :validate_nsfw_content, if: -> { photo.attached? && !@file_processed }
  # after_update :validate_nsfw_content
  has_one_attached :photo

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  has_many :mentor_matches, class_name: 'Match', foreign_key: 'mentor_id', dependent: :destroy
  has_many :mentee_matches, class_name: 'Match', foreign_key: 'mentee_id', dependent: :destroy

  validates :first_name, :last_name, :email, :country, :city, :state, :professional_field, :academic_degree, presence: true
  validates :github, format: { with: /\A[A-Za-z0-9]+\z/ }, uniqueness: { case_sensitive: false }, allow_blank: true, unless :github.nil?
  validates :linkedin, format: { with: /https:\/\/www\.linkedin\.com\/in\/.*/ }, uniqueness: true, allow_blank: true

  include CloudinaryHelper

  include PgSearch::Model

  PROFESSIONAL_FIELDS = ["Tecnologia", "Saúde", "Educação", "Engenharias", "Ciências Exatas", "Música, Artes e Design", "Ciências Sociais",  "Comunicação e Informação", "Negócios", "Ciências Biológicas", "Direito", "Outros"]
  FIELDS_OF_WORK = ["Full-stack", "Front-end", "Back-end", "Product Manager", "UX/UI Designer", "Data Analyst", "Data Engineer", "Data Scientist"]
  PROGRAMMING_LANGUAGES = ["Assembly", "C", "C++", "C#", "Dart", "Delphi/Object Pascal", "Go", "Groovy", "Haskell", "HTML/CSS", "Java", "JavaScript", "Kotlin", "Lua", "MATLAB", "Objective-C", "Perl", "PHP", "PowerShell", "Python", "R", "Ruby", "Rust", "Scala", "Shell", "Solidity", "SQL", "Swift", "TypeScript", "VB.NET", "Outra", "Nenhuma"]

  pg_search_scope :search_user,
                  against: %i[first_name last_name id email],
                  using: {
                    tsearch: { prefix: true }
                  }
  def validate_nsfw_content
    @file_processed = true
    return unless photo.attached?

    image_url = photo.url
    nsfw_service = NsfwDetectionService.new(image_url)
    nsfw_result = nsfw_service.detect_nsfw_content
    photo.purge if nsfw_result == true
  end
end
