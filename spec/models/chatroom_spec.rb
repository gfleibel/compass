require 'rails_helper'

RSpec.describe Chatroom, type: :model do
  describe "associations" do
    it { should belong_to(:match) }
    it { should have_many(:messages).dependent(:destroy) }
  end
end
