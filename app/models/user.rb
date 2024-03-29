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
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]{2,}\z/i}
  validates :github, format: { with: /\A[A-Za-z0-9][-A-Za-z0-9]{0,38}\z/ }, allow_blank: true
  validates :linkedin, format: { with: /https:\/\/www\.linkedin\.com\/in\/.*/ }, allow_blank: true

  include CloudinaryHelper

  include PgSearch::Model

  PROFESSIONAL_FIELDS = ["Tecnologia", "Saúde", "Educação", "Engenharias", "Ciências Exatas", "Música, Artes e Design", "Ciências Sociais",  "Comunicação e Informação", "Negócios", "Ciências Biológicas", "Direito", "Outros"]
  FIELDS_OF_WORK = ["Full-stack", "Front-end", "Back-end", "Product Manager", "UX/UI Designer", "Data Analyst", "Data Engineer", "Data Scientist"]
  PROGRAMMING_LANGUAGES = [
    "Alibaba Cloud", "Angular", "ASP.NET Core", "Assembly", "AWS (Amazon Web Services)",
    "Azure (Microsoft Azure)", "Bootstrap", "C", "C#", "C++", "CakePHP", "Chai", "CodeIgniter",
    "Dart", "Delphi/Object Pascal", "DigitalOcean", "Django REST framework", "Ember.js", "Express.js",
    "FastAPI", "Flask", "Flask-RESTful", "Gin", "Go", "Google Cloud Platform (GCP)", "Groovy",
    "Haskell", "Heroku", "HTML/CSS", "IBM Cloud", "Ionic", "JavaScript", "Java", "Jest", "JHipster", "JUnit", "jQuery",
    "Karma", "Kotlin", "Kubernetes", "Laravel", "Lua", "Material-UI", "MATLAB", "Meteor", "Mocha",
    "Next.js", "NestJS", "Nuxt.js", "Objective-C", "OpenStack", "Oracle Cloud", "Outra", "Pandas",
    "Perl", "PHP", "Play Framework", "PowerShell", "PyTorch", "Python", "R", "React.js", "React Native", "RSpec",
    "Ruby", "Ruby on Rails", "Rust", "Scala", "Scikit-learn", "Shell", "Slim", "Solidity", "Spring Boot",
    "SQL", "Swift", "Symfony", "TensorFlow", "TypeScript", "VB.NET", "Vue.js", "Vapor"
]
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
