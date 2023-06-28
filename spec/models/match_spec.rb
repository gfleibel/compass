require 'rails_helper'

RSpec.describe Match, type: :model do
  let(:mentor) { User.create(first_name: "Jane", last_name: "Doe", email: "janedoe@example.com", encrypted_password: Devise::Encryptor.digest(User, 'password'), country: "Brazil", city: "Rio de Janeiro", state: "RJ", professional_field: "Negócios", academic_degree: "Administração") }
  let(:mentee) { User.create(first_name: "John", last_name: "Doe", email: "johndoe2@example.com", encrypted_password: Devise::Encryptor.digest(User, 'password'), country: "Brazil", city: "São Paulo", state: "SP", professional_field: "Tecnologia", academic_degree: "Ciências da Computação") }

  it "is valid with valid attributes" do
    expect(Match.create(mentee: mentee, mentor: mentor)).to be_valid
  end

  it "is not valid without a mentee" do
    match = Match.new(mentor_id: mentor.id)
    match.valid?
    expect(match.errors[:mentee]).to include("é obrigatório(a)") # Update the expected error message
  end

  it "is not valid without a mentor" do
    match = Match.new(mentee_id: mentee.id)
    match.valid?
    expect(match.errors[:mentor]).to include("é obrigatório(a)") # Update the expected error message
  end

  it "is not valid if the same mentee and mentor combination already exists" do
    match = Match.new(mentee: mentee, mentor: mentor)
    match.save

    duplicate_match = nil

    ActiveRecord::Base.transaction do
      duplicate_match = Match.new(mentee: mentee, mentor: mentor)
      duplicate_match.valid?
    end

    expect(duplicate_match.errors[:mentor_id]).to include("já está em uso")
  end

  it "does not create a chatroom after creation when not matched" do
    match = Match.new(mentee: mentee, mentor: mentor, matched: false)
    match.save
    expect(match.chatroom).to be_nil
  end

  it "sends welcome emails to the mentor and mentee after creation" do
    allow_any_instance_of(UserMailer).to receive(:welcome_mentor).and_return(double("email", deliver_later: true))
    allow_any_instance_of(UserMailer).to receive(:welcome_mentee).and_return(double("email", deliver_later: true))

    Match.create(mentee_id: mentee.id, mentor_id: mentor.id)
  end
end
