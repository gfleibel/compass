require 'rails_helper'

RSpec.describe User, type: :model do

  describe "validations" do
    it "is valid with valid attributes" do
      user = User.new(
        first_name: "John",
        last_name: "Doe",
        email: "john2@example.com",
        password: "password",
        country: "Brasil",
        city: "São Paulo",
        state: "SP",
        professional_field: "Tecnologia",
        academic_degree: "Ciências da Computação"
      )
      expect(user).to be_valid
    end

    it "is not valid without a first name" do
      user = User.new(first_name: nil)
      expect(user).not_to be_valid
      expect(user.errors[:first_name]).to be_present
    end

    it "is not valid without a last name" do
      user = User.new(last_name: nil)
      expect(user).not_to be_valid
      expect(user.errors[:last_name]).to be_present
    end

    it "is not valid without an email" do
      user = User.new(email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to be_present
    end

    it "is not valid without a country" do
      user = User.new(country: nil)
      expect(user).not_to be_valid
      expect(user.errors[:country]).to be_present
    end

    it "is not valid without a city" do
      user = User.new(city: nil)
      expect(user).not_to be_valid
      expect(user.errors[:city]).to be_present
    end

    it "is not valid without a state" do
      user = User.new(state: nil)
      expect(user).not_to be_valid
      expect(user.errors[:state]).to be_present
    end

    it "is not valid without a professional field" do
      user = User.new(professional_field: nil)
      expect(user).not_to be_valid
      expect(user.errors[:professional_field]).to be_present
    end

    it "is not valid without an academic degree" do
      user = User.new(academic_degree: nil)
      expect(user).not_to be_valid
      expect(user.errors[:academic_degree]).to be_present
    end

    it "is not valid with an invalid GitHub username format" do
      user = User.new(github: "invalid username")
      expect(user).not_to be_valid
      expect(user.errors[:github]).to be_present
    end

    it "is not valid with a duplicate GitHub username" do
      existing_user = User.new(github: "existinguser")
      existing_user.save(validate: false)

      user = User.new(github: "existinguser")
      expect(user).not_to be_valid
      expect(user.errors[:github]).to include(I18n.t("errors.messages.taken"))
    end

    it "is not valid with an invalid LinkedIn profile URL format" do
      user = User.new(linkedin: "invalid_url")
      expect(user).not_to be_valid
      expect(user.errors[:linkedin]).to be_present
    end
  end

  describe "associations" do
    it "has many mentor_matches" do
      expect(User.reflect_on_association(:mentor_matches).macro).to eq(:has_many)
      expect(User.reflect_on_association(:mentor_matches).options[:foreign_key]).to eq('mentor_id')
      expect(User.reflect_on_association(:mentor_matches).options[:dependent]).to eq(:destroy)
    end

    it "has many mentee_matches" do
      expect(User.reflect_on_association(:mentee_matches).macro).to eq(:has_many)
      expect(User.reflect_on_association(:mentee_matches).options[:foreign_key]).to eq('mentee_id')
      expect(User.reflect_on_association(:mentee_matches).options[:dependent]).to eq(:destroy)
    end
  end

  describe "methods" do
    it "does not execute validate_nsfw_content after commit when photo is not attached" do
      user = User.new
      expect(user).not_to receive(:validate_nsfw_content)
      user.save
    end

    it "does not execute validate_nsfw_content after commit when @file_processed is true" do
      user = User.new(photo: fixture_file_upload(Rails.root.join('spec', 'fixtures', 'images', 'sample_image.jpg'), 'image/jpeg'))
      user.instance_variable_set(:@file_processed, false)
      expect(user).not_to receive(:validate_nsfw_content)
      user.save
    end
  end

  describe "class constants" do
    it "defines PROFESSIONAL_FIELDS" do
      expect(User::PROFESSIONAL_FIELDS).to eq(["Tecnologia", "Saúde", "Educação", "Engenharias", "Ciências Exatas", "Música, Artes e Design", "Ciências Sociais", "Comunicação e Informação", "Negócios", "Ciências Biológicas", "Direito", "Outros"])
    end

    it "defines FIELDS_OF_WORK" do
      expect(User::FIELDS_OF_WORK).to eq(["Full-stack", "Front-end", "Back-end", "Product Manager", "UX/UI Designer", "Data Analyst", "Data Engineer", "Data Scientist"])
    end

    it "defines PROGRAMMING_LANGUAGES" do
      expect(User::PROGRAMMING_LANGUAGES).to eq(["Assembly", "C", "C++", "C#", "Dart", "Delphi/Object Pascal", "Go", "Groovy", "Haskell", "HTML/CSS", "Java", "JavaScript", "Kotlin", "Lua", "MATLAB", "Objective-C", "Perl", "PHP", "PowerShell", "Python", "R", "Ruby", "Rust", "Scala", "Shell", "Solidity", "SQL", "Swift", "TypeScript", "VB.NET", "Outra", "Nenhuma"])
    end
  end
end
