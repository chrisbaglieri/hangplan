# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :identity do
    source "MyString"
    identity "MyString"
    access_token "MyString"
  end
end
