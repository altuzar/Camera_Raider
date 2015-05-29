# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :camera do
    sucursal 1
    numcamera 1
    ipaddress "MyString"
    user "MyString"
    pass "MyString"
    tags "MyString"
    status 1
  end
end
