# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :special_date do
    date "2014-03-26"
    store 1
    open 1
    close 1
  end
end
