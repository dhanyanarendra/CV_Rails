require 'rails_helper'

RSpec.describe Feed, type: :model do

  let!(:feed) {FactoryGirl.build(:feed)}
  context "Factory" do
    it "should validate all the feed" do
      expect(FactoryGirl.build(:feed).valid?).to be true
    end
  end

  context "Associations" do
    it { should have_many(:likes) }
    it { should have_many(:pledges) }
    it { should belong_to(:user)}
    it { should belong_to(:campaign)}
    it { should belong_to(:interest)}
  end

  context "Validations" do
    it {should validate_presence_of :title }
    it {should validate_presence_of :interest_id }
    it {should validate_presence_of :short_description }
    it {should validate_presence_of :quantity }
    it {should validate_presence_of :start_time}
    it {should validate_presence_of :end_time}
    it {should validate_presence_of :date}
    it {should validate_presence_of :location}
  end


end
