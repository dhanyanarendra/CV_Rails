require 'rails_helper'

RSpec.describe Pledge, type: :model do
  context "Factory" do
    it "should validate all the pledges" do
      expect(FactoryGirl.build(:pledge).valid?).to be true
    end
  end

  context "Associations" do
    it { should belong_to(:feed) }
    it { should belong_to(:user) }
  end
end
