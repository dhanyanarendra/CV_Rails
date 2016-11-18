require 'rails_helper'

RSpec.describe Interest, type: :model do

  let!(:interest) {FactoryGirl.build(:interest)}
  context "Factory" do
    it "should validate all the feed" do
      expect(FactoryGirl.build(:interest).valid?).to be true
    end
  end

  context "Associations" do
    it { should have_many(:feeds) }
  end

  context "Validations" do
    it {should validate_presence_of :name }
  end
end
