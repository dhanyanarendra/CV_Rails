FactoryGirl.define do
  factory :user do
    email "example@yopmail.com"
    password "password123"
    name "SampleFirstName"
    phone "303-655-2554"
    address "CompanyName"
    title "SampleLocation"
  end
end