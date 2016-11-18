require 'rails_helper'

RSpec.describe Role, type: :model do
  context "Factory" do
    it "should validate the role" do
      expect(FactoryGirl.build(:role).valid?).to be true
    end
  end

  context "Associations" do
    it { should have_and_belong_to_many(:users)}
  end
end
