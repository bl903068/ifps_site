FactoryGirl.define do
  factory :user do
    name     "Hartl"
    first_name "Michael"
    labo "Bibliotheque bidon"
    email    "michael@example.com"
    password "fooooobar"
    password_confirmation "fooooobar"
  end
end