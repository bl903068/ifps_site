require 'spec_helper'

describe User do

	before do
		@user = User.new(name: "Example User", first_name: "Example User", labo: "Example labo", email: "user@example.com", password: "fooooobar", password_confirmation: "fooooobar" )
	end

	subject { @user }

	it { should respond_to(:name) }
	it { should respond_to(:first_name) }
	it { should respond_to(:labo) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:remember_token) }
	it { should respond_to(:authenticate) }
	it { should respond_to(:publications) }
	it { should respond_to(:feed) }
	it { should respond_to(:relationships) }
	it { should respond_to(:followed_publications) }
	it { should respond_to(:following?) }
	it { should respond_to(:follow!) }
	it { should respond_to(:unfollow!) }

	it { should be_valid }
	

	describe "when name is not present" do
		before { @user.name = " " }
		it { should_not be_valid }
	end

	describe "when name is too long" do
		before { @user.name = "a" * 51 }
		it { should_not be_valid }
	end

	describe "when first_name is not present" do
		before { @user.first_name = " " }
		it { should_not be_valid }
	end

	describe "when first_name is too long" do
		before { @user.first_name = "a" * 51 }
		it { should_not be_valid }
	end

	describe "when labo is not present" do
		before { @user.labo = " " }
		it { should_not be_valid }
	end

	describe "when labo is too long" do
		before { @user.labo = "a" * 101 }
		it { should_not be_valid }
	end

	describe "when email format is invalid" do
    	it "should be invalid" do
      		addresses = %w[user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com]
      		addresses.each do |invalid_address|
        		@user.email = invalid_address
        		@user.should_not be_valid
      		end      
    	end
  	end

  	describe "when email format is valid" do
    	it "should be valid" do
      		addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      		addresses.each do |valid_address|
        		@user.email = valid_address
        		@user.should be_valid
      		end      
    	end
  	end

	describe "when email address is already taken" do
		before do
			user_with_same_email = @user.dup
			user_with_same_email.email = @user.email.upcase
			user_with_same_email.save
		end

		it { should_not be_valid }
	end

	describe "when password is not present" do
		before { @user.password = @user.password_confirmation = " " }
		it { should_not be_valid }
	end

	describe "when password doesn't match confirmation" do
		before { @user.password_confirmation = "mismatch" }
		it { should_not be_valid }
	end

	describe "when password confirmation is nil" do
		before { @user.password_confirmation = nil }
		it { should_not be_valid }
	end

	describe "return value of authenticate method" do
  		before { @user.save }
  		let(:found_user) { User.find_by_email(@user.email) }

  		describe "with valid password" do
    		it { should == found_user.authenticate(@user.password) }
  		end

  		describe "with invalid password" do
    		let(:user_for_invalid_password) { found_user.authenticate("invalid") }

    		it { should_not == user_for_invalid_password }
    		specify { user_for_invalid_password.should be_false }
  		end
  	end

	describe "with a password that's too short" do
		before { @user.password = @user.password_confirmation = "a" * 7 }
		it { should be_invalid }
	end

	describe "remember token" do
		before { @user.save }
		its(:remember_token) { should_not be_blank }
	end

	describe "publication associations" do

		before { @user.save }
		let!(:older_publication) do
			FactoryGirl.create(:publication, user: @user, created_at: 1.day.ago)
		end
		let!(:newer_publication) do
			FactoryGirl.create(:publication, user: @user, created_at: 1.hour.ago)
		end

		it "should have the right publications in the right order" do
			@user.publications.should == [newer_publication, older_publication]
		end

		it "should destroy associated publications" do
			publications = @user.publications.dup
			@user.destroy
			publications.should_not be_empty
			publications.each do |publication|
				Publication.find_by_id(publication.id).should be_nil
			end
		end

		describe "status" do
			let(:unfollowed_post) do
				FactoryGirl.create(:publication, user: FactoryGirl.create(:user))
			end

			its(:feed) { should include(newer_publication) }
			its(:feed) { should include(older_publication) }
			its(:feed) { should_not include(unfollowed_post) }
		end
	end

	describe "following" do
		let(:other_publication) { FactoryGirl.create(:publication) }
		before do
			@user.save
			@user.follow!(other_publication)
		end

		it { should be_following(other_publication) }
		its(:followed_publications) { should include(other_publication) }

		describe "and unfollowing" do
			before { @user.unfollow!(other_publication) }

			it { should_not be_following(other_publication) }
			its(:followed_publications) { should_not include(other_publication) }
		end
		describe "followed publication" do
			subject { other_publication }
			its(:followers) { should include(@user) }
		end
	end
end