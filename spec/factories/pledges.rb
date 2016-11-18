FactoryGirl.define do
  factory :pledge do
    priority_done false
    pledge_done false
    user_contributor_id 1
    feed_id 1
    pledged true
  end

end
