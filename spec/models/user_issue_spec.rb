require 'rails_helper'

RSpec.describe UserIssue, type: :model do

  context "Associations" do
    it { should belong_to(:user) }
    it { should belong_to(:issue) }
  end
end
