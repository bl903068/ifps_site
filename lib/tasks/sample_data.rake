namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_publications
    make_relationships
  end
end

def make_users
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

def make_publications
  users = User.all(limit: 6)
  50.times do |n|
    title = "title-#{n+1}"
    ptype = "News"
    nameofpublication = "Conf"
    resume = Faker::Lorem.sentence(5)
    content = Faker::Lorem.sentence(50)
    users.each { |user| user.publications.create!(title: title,
     ptype: ptype, nameofpublication: nameofpublication,
     resume: resume, content: content) }
  end
end

def make_relationships
  
  title = "title"
  ptype = "News"
  nameofpublication = "Conf"
  resume = Faker::Lorem.sentence(5)
  content = Faker::Lorem.sentence(50)

  users = User.all
  user = users.first
  publication = user.publications.create!(title: title,
     ptype: ptype, nameofpublication: nameofpublication,
     resume: resume, content: content)

  
  followers = users[3..40]
  followers.each { |follower| follower.follow!(publication) }
end