# # This file should contain all the record creation needed to seed the database with its default values.
# # The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
# #
# # Examples:
# #
# #   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
# #   Character.create(name: "Luke", movie: movies.first)

# require 'open-uri'
# require 'unsplash'
# # Seed Users
# puts 'Starting seed...'
# # User.where(mentor: true).destroy_all

# puts 'Creating mentors...'

# Unsplash.configure do |config|
#   config.application_access_key = "q3CUY3MkcmFT_14OwLac1B7RlG4gFjahNyUz274LfPw"
#   config.application_secret = "vBmhRU-MGWaiiFUGT7wVr0JXUOP9kIvaG_uKLwaCVBw"
#   config.application_redirect_uri = "https://your-application.com/oauth/callback"
#   config.utm_source = "alices_terrific_client_app"
# end

# PROFESSIONAL_FIELD = ["Tecnologia", "Saúde", "Educação", "Engenharias", "Ciências Exatas", "Música, Artes e Design", "Ciências Sociais",  "Comunicação e Informação", "Negócios", "Ciências Biológicas", "Direito", "Outros"]
# PROGRAMMING_LANGUAGE = ["Assembly", "C", "C++", "C#", "Dart", "Delphi/Object Pascal", "Go", "Groovy", "Haskell", "HTML/CSS", "Java", "JavaScript", "Kotlin", "Lua", "MATLAB", "Objective-C", "Perl", "PHP", "PowerShell", "Python", "R", "Ruby", "Rust", "Scala", "Shell", "SQL", "Swift", "TypeScript", "VB.NET", "Outra", "Nenhuma"]
# YEARS_OF_EXPERIENCE = ["Menos de 1 ano", "1 a 3 anos", "3 a 5 anos", "5 a 10 anos", "Mais de 10 anos"]
# FIELD_OF_WORK = ["Full-stack", "Front-end", "Back-end", "Product Manager", "UX/UI Designer", "Data Analyst", "Data Engineer", "Data Scientist"]
# 2.times do
#   mentor = User.new(email: Faker::Internet.email,
#     password: "123456",
#     first_name: Faker::Name.first_name,
#     last_name: Faker::Name.last_name,
#     country: Faker::Address.country,
#     state: Faker::Address.state,
#     city: Faker::Address.city,
#     professional_field: PROFESSIONAL_FIELD.sample,
#     academic_degree: Faker::Educator.degree,
#     programming_language: PROGRAMMING_LANGUAGE.sample,
#     mentor_current_employer: Faker::Company.name,
#     transition_description: Faker::Lorem.paragraph,
#     years_of_experience: YEARS_OF_EXPERIENCE.sample,
#     mentor: true,
#     field_of_work:FIELD_OF_WORK.sample)

#   mentor_photo = Unsplash::Photo.random(query: "person")

#   if mentor_photo.present?
#     mentor.photo.attach(io: URI.open(mentor_photo.urls.regular), filename: 'mentor_photo.jpg')
#     mentor.save!
#   else
#     puts "Failed to find a mentor photo"
#   end
# end

# puts "#{User.where(mentor: true).count} mentors created!"
# puts 'Finished! :D'



# script confirmacao email de usuarios ja existentes

users = User.where.not(id: [1, 3, 28])

users.each do |user|
  user.confirmation_token = Devise.friendly_token
  user.confirmation_sent_at = Time.now.utc
  user.save
  user.confirmed_at = Time.now.utc

  # UserMailer.confirmation_instructions(user).deliver_now
end
