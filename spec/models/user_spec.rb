require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) {FactoryGirl.build(:user)}
  context "Factory" do
    it "should validate all the user" do
      expect(FactoryGirl.build(:user).valid?).to be true
    end
  end

  context "Associations" do
    it { should have_many(:user_issues) }
    it { should have_many(:pledges) }
    it { should have_many(:feeds) }
    it { should belong_to(:campaign) }
    it { should have_many(:issues).through(:user_issues) }
  end


  context "Validations" do
    it {should validate_presence_of :email }
    it {should validate_presence_of :password }
  end

  context "Instance Methods" do
    it "generate_auth_token" do
      user = FactoryGirl.build(:user)
      expect(user.auth_token).to be_nil
      user.generate_auth_token
      expect(user.auth_token).to_not be_nil
    end
  end
end
