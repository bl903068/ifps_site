require 'spec_helper'

describe "Publication Pages" do

	subject { page }

	describe "publication creation" do
		let(:user) { FactoryGirl.create(:user) }
		before { sign_in user }
		before { visit root_path }

		describe "with invalid information" do

			it "should not create a publication" do
				expect { click_button "Post" }.not_to change(Publication, :count)
			end

			describe "error messages" do
				before { click_button "Post" }
				it { should have_content('error') }
			end
		end

		describe "with valid information" do

			before do
				fill_in "publication_title", with: "Example title"
				fill_in "publication_ptype",	with: "Example type"
				fill_in "publication_nameofpublication", with: "Example name of publication"
				fill_in "publication_resume", with: "Example resume"
				fill_in "publication_content", with: "Example content of publication"
			end
			it "should create a publication" do
				expect { click_button "Post" }.to change(Publication, :count).by(1)
			end
		end
	end
	
	describe "publication destruction" do
		let(:user) { FactoryGirl.create(:user) }
 		before { sign_in user }
		before { FactoryGirl.create(:publication, user: user) }

		describe "as correct user" do
			before { visit root_path }

			it "should delete a publication" do
				expect { click_link "delete" }.to change(Publication, :count).by(-1)
			end
		end
	end

	describe "index" do
		let(:user) { FactoryGirl.create(:user) }

		before(:each) do
			visit publications_path
		end

		it { should have_selector('title', 'All publications') }
		it { should have_selector('h1', text: 'All publications') }

		describe "pagination" do
			before(:all) { 30.times { FactoryGirl.create(:publication) } }
			after(:all) { Publication.delete_all }

			it "should list each publication" do
				Publication.paginate(page: 1).each do |publication|
					page.should have_selector('h4', text: publication.title)
					page.should have_selector('span', text: publication.ptype)
					page.should have_selector('span', text: publication.nameofpublication)
					page.should have_selector('span', text: publication.resume)
				end
			end
		end
	end

	describe "publication page" do
		let(:user) { FactoryGirl.create(:user) }
		let!(:publi) { FactoryGirl.create(:publication, user: user, title: "title 1", ptype: "type 1", nameofpublication: "nameofpublication 1", resume: "resume 1", content: "cont 1") }
		
		before { visit publication_path(publi) }

		it { should have_selector('title', publi.title) }
		it { should have_selector('h1',    publi.title) }

		describe "publications" do
			it { should have_content(publi.title) }
			it { should have_content(publi.ptype) }
			it { should have_content(publi.nameofpublication) }
			it { should have_content(publi.content) }
		end
	end

	
	describe "follow/unfollow buttons" do
      	let(:other_user) { FactoryGirl.create(:user) }
      	let(:other_publication) { FactoryGirl.create(:publication) }
      	before { sign_in other_user }

      	describe "following a user" do
        	before do 
        		visit publication_path(other_publication)
        	end

        	it "should increment the followed user count" do
        	  	expect do
            		click_button "Im Author of this Publication"
          		end.to change(other_user.followed_publications, :count).by(1)
        	end

       		it "should increment the other user's followers count" do
          		expect do
            		click_button "Im Author of this Publication"
          		end.to change(other_publication.followers, :count).by(1)
        	end

        	describe "toggling the button" do
          		before do 
          			click_button "Im Author of this Publication"
          		end
          		it { should have_selector("input[value= 'I make mistake']") }
        	end
      	end

      	describe "unfollowing a user" do
        	before do
          		other_user.follow!(other_publication)
          		visit publication_path(other_publication)
        	end

        	it "should decrement the followed user count" do
          		expect do
            		click_button "I make mistake"
          		end.to change(other_user.followed_publications, :count).by(-1)
        	end

        	it "should decrement the other user's followers count" do
          		expect do
            		click_button "I make mistake"
          		end.to change(other_publication.followers, :count).by(-1)
        	end

        	describe "toggling the button" do
          		before { click_button "I make mistake" }
          		it { should have_selector("input[value= 'Im Author of this Publication']") }
        	end
        end
    end
end