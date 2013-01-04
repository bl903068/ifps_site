require 'spec_helper'

describe "Publication Pages" do

	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	before { sign_in user }

	describe "publication creation" do
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
end