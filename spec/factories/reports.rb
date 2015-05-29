# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :report do
    ident 1
    user 1
    filter "MyText"
    duration 1
    results 1
    finished false
  end
end
