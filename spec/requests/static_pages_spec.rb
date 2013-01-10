require 'spec_helper'

describe "Static pages" do

	subject { page }

	describe "Home page" do
		before { visit root_path } 

    	it { should have_selector('h1', text: 'Welcome') }
    	it { should have_selector('title', "Site IFPS") }
    	it { should_not have_selector('title', text: '| Home') }

    	describe "for signed-in users" do
    		let(:user) { FactoryGirl.create(:user) }
    		before do
    			FactoryGirl.create(:publication, user: user, title: "title 1",
    			 ptype: "type 1",
    			 nameofpublication: "nameofpublication 1",
    			 resume: "resume 1",
    			 content: "cont 1")
    			FactoryGirl.create(:publication, user: user, title: "title 2",
    			 ptype: "type 2",
    			 nameofpublication: "nameofpublication 2",
    			 resume: "resume 2",
    			 content: "cont 2")
    			sign_in user
    			visit root_path
    		end

    		it "should render the user's feed" do
    			user.feed.each do |item|
    				page.should have_selector("li##{item.id}", text: item.title)
    			end
    		end

    		describe "follower/following counts" do
    			let(:other_user) { FactoryGirl.create(:user) }
    			let(:other_publication) { FactoryGirl.create(:publication) }

                describe "followers counts invisible" do
                    before do
                        visit publication_path(other_publication)
                    end

                    it { should_not have_link("0 authors", href: followers_publication_path(other_publication)) }
                end

    			before do
    				other_user.follow!(other_publication)
    			end

    			describe "following counts" do
	    			before do
    					visit root_path
    				end

    				it { should have_link("0 co-writted publications", href: following_user_path(user)) }
    			end

    			describe "followers counts" do
    				before do
    					visit publication_path(other_publication)
    				end

    				it { should have_link("1 authors", href: followers_publication_path(other_publication)) }
    			end
    		end
    	end
    end
end