FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    first_name "Michael"
    labo "Bibliotheque bidon"
    password "fooooobar"
    password_confirmation "fooooobar"

    factory :admin do
    	admin true
    end
  end

  factory :publication do
  	title "Test title"
  	ptype "News"
  	nameofpublication "QN News"
  	resume "this is resume test"
  	content "test content of publication"
  	user
  end
end