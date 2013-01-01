FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    first_name "Michael"
    labo "Bibliotheque bidon"
    password "fooooobar"
    password_confirmation "fooooobar"
  end
end