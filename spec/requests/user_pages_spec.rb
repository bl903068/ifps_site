require 'spec_helper'

describe "User pages" do
	subject { page }

	describe "profile page" do
		let(:user) { FactoryGirl.create(:user) }
		before { visit user_path(user) }

		it { should have_selector('title', user.name) }
		it { should have_selector('h1',    user.name) }
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
end