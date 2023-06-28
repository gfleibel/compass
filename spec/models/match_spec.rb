require 'rails_helper'

RSpec.describe Match, type: :model do
  fixtures :users

  let(:mentee) { users(:fake_mentee) }
  let(:mentor) { users(:fake_mentor) }

  it "is valid with valid attributes" do
    expect(Match.create(mentee_id: mentee.id, mentor_id: mentor.id)).to be_valid
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
    Match.create(mentee_id: mentee.id, mentor_id: mentor.id)

    duplicate_match = Match.new(mentee_id: mentee.id, mentor_id: mentor.id)
    duplicate_match.valid?
    expect(duplicate_match.errors[:mentor_id]).to include("já está em uso") # Update the expected error message
  end

  it "does not create a chatroom after creation when not matched" do
    match = Match.new(mentee_id: mentee.id, mentor_id: mentor.id, matched: false)
    match.save
    expect(match.reload.chatroom).to be_nil
  end

  it "sends welcome emails to the mentor and mentee after creation" do
    expect(UserMailer).to receive(:with).with(user: mentor.id, mentee: mentee.id).and_return(double("mailer", welcome_mentor: double("email", deliver_later: true)))
    expect(UserMailer).to receive(:with).with(user: mentee.id, mentor: mentor.id).and_return(double("mailer", welcome_mentee: double("email", deliver_later: true)))

    Match.create(mentee_id: mentee.id, mentor_id: mentor.id)
  end
end
