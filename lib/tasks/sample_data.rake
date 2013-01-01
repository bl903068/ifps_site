namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(name: "Example",
    			 first_name: "User",
    			 labo: "biblio bidon",
                 email: "example@railstutorial.org",
                 password: "fooooobar",
                 password_confirmation: "fooooobar")
    99.times do |n|
      name  = Faker::Name.name
      first_name = "john"
      labo = "biblio bidon"
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
      			   first_name: first_name,
      			   labo: labo,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
  end
end