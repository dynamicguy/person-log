# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :permission do
    action "MyString"
    subject_class "MyString"
    subject_id "MyString"
    user ""
  end
end
