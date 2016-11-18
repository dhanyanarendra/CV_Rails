require 'rails_helper'

RSpec.describe Invite, type: :model do

  let!(:invite) {FactoryGirl.build(:invite)}
  context "Factory" do
    it "should validate all the feed" do
      expect(FactoryGirl.build(:invite).valid?).to be true
    end
  end

  context "Associations" do
    it { should have_one(:user) }
    it { should belong_to(:campaign) }
  end

  context "Validations" do
    it {should validate_presence_of :email }
  end
end

