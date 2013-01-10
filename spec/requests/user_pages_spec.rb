require 'spec_helper'

describe "User pages" do

	subject { page }

	describe "index" do

		let(:user) { FactoryGirl.create(:user) }

		before(:each) do
			sign_in user
			visit users_path
		end

		it { should have_selector('title', 'All users') }
		it { should have_selector('h1', text: 'All users') }

		describe "pagination" do
			before(:all) { 30.times { FactoryGirl.create(:user) } }
			after(:all) { User.delete_all }

			it { should have_selector('div.pagination') }

			it "should list each user" do
				User.paginate(page: 1).each do |user|
					page.should have_selector('li', text: user.name)
				end
			end
		end
	end

	describe "profile page" do
		let(:user) { FactoryGirl.create(:user) }
		let!(:m1) { FactoryGirl.create(:publication, user: user, title: "title 1", ptype: "type 1", nameofpublication: "nameofpublication 1", resume: "resume 1", content: "cont 1") }
		let!(:m2) { FactoryGirl.create(:publication, user: user, title: "title 2", ptype: "type 2", nameofpublication: "nameofpublication 2", resume: "resume 2", content: "cont 2") }
		
		before { visit user_path(user) }

		it { should have_selector('title', user.name) }
		it { should have_selector('h1',    user.name) }

		describe "publications" do
			it { should have_content(m1.title) }
			it { should have_content(m1.ptype) }
			it { should have_content(m1.nameofpublication) }
			it { should have_content(m1.resume) }

			it { should have_content(m2.title) }
			it { should have_content(m2.ptype) }
			it { should have_content(m2.nameofpublication) }
			it { should have_content(m2.resume) }
			it { should have_content(user.publications.count) }
		end
	end

	describe "signup page" do
		before { visit signup_path }

		it { should have_selector('title', 'Sign up') }
		it { should have_selector('h1',    'Sign up') }
	end

	describe "signup" do
		before { visit signup_path }

		let(:submit) { "Create my account" }

		describe "with invalid information" do
			it "should not create a user" do
				expect { click_button submit }.not_to change(User, :count)
			end
		end

		describe "with valid information" do
			before do
				fill_in "Name",         with: "Example"
				fill_in "First",		with: "User"
				fill_in "Labo",			with: "Example labo"
				fill_in "Email",        with: "user@example.com"
				fill_in "Password",     with: "fooooobar"
				fill_in "Confirmation", with: "fooooobar"
			end

			it "should create a user" do
				expect { click_button submit }.to change(User, :count).by(1)
			end
		end
	end

	describe "edit" do
		let(:user) { FactoryGirl.create(:user) }
		before do
			sign_in user
			visit edit_user_path(user)
		end

		describe "page" do
			it { should have_selector('h1', text: "Update your profile") }
			it { should have_selector('title', "Edit user") }
		end

		describe "with invalid information" do
			before { click_button "Save changes" }

			it { should have_content('error') }
		end

		describe "with valid information" do
			let(:new_name) { "New Name" }
			let(:new_labo) { "New labo" }
			let(:new_email) { "new@example.com" }
			before do
				fill_in "Name",	with: new_name
				fill_in "First", with: user.first_name
				fill_in "Labo", with: new_labo
				fill_in "Email", with: new_email
				fill_in "Password", with: user.password
        		fill_in "Confirm", with: user.password
				click_button "Save changes"
			end

			it { should have_selector('title', new_name) }
			it { should have_selector('div.alert.alert-success') }
			it { should have_link('Sign out', href: signout_path) }
			specify { user.reload.name.should == new_name }
			specify { user.reload.labo.should == new_labo }
			specify { user.reload.email.should == new_email }
		end
	end

	describe "following/followers" do
	    let(:user) { FactoryGirl.create(:user) }
    	let(:publication) { FactoryGirl.create(:publication) }
    	before { user.follow!(publication) }

    	before do
    		sign_in user
    	end

    	describe "followed users" do
      		before do
        		visit following_user_path(user)
      		end

      		it { should have_selector('title', full_title('Publications co-writted')) }
      		it { should have_selector('h3', text: 'Publications co-writted') }
      		it { should have_link(publication.title, href: publication_path(publication)) }
    	end

    	describe "followers" do
      		before do
		        visit followers_publication_path(publication)
      		end

      		it { should have_selector('title', full_title('Authors')) }
      		it { should have_selector('h3', text: 'Authors') }
      		it { should have_link(user.name, href: user_path(user)) }
    	end
    end    
end