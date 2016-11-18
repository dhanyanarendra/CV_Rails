require 'rails_helper'

RSpec.describe Issue, type: :model do
  let!(:issue) {FactoryGirl.build(:issue)}
  context "Factory" do
    it "should validate all the issue" do
      expect(FactoryGirl.build(:issue).valid?).to be true
    end
  end

  context "Associations" do
    it { should have_many(:user_issues) }
    it { should have_many(:user).through(:user_issues) }
  end

  context "Validations" do
    it {should validate_presence_of :name }
  end
end
