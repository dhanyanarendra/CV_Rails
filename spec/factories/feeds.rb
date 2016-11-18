FactoryGirl.define do
  factory :feed do
    title "MyString"
    quantity 1
    date "2016-06-06"
    start_time "2016-06-06 11:14:01"
    end_time "2016-06-06 11:14:01"
    location "MyString"
    short_description "MyText"
    campaign_id 1
    pledge false
    priority false
    done false
    user_id 1
    interest_id 1
  end

end
