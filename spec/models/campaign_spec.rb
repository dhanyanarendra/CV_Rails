require 'rails_helper'

RSpec.describe Campaign, type: :model do

  let!(:campaign) {FactoryGirl.build(:campaign)}
  context "Factory" do
    it "should validate all the campaign" do
      expect(FactoryGirl.build(:campaign).valid?).to be true
    end
  end

  context "Associations" do
    it { should have_many(:feeds) }
    it { should have_many(:users)}
  end

  context "Validations" do
    it {should validate_presence_of :candidate_name }
    it {should validate_presence_of :district }
    it {should validate_presence_of :year}
    it {should validate_presence_of :state}
    it {should validate_presence_of :election}
  end

end
