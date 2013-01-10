require 'spec_helper'

describe Publication do

	let(:user) {FactoryGirl.create(:user) }
	before { @publication = user.publications.build(title: "TestTitle", ptype:"News", nameofpublication:"QN News", resume:"this is test", content:"test for publication is good") }

	subject { @publication }

	it { should respond_to(:title) }
	it { should respond_to(:ptype) }
	it { should respond_to(:nameofpublication) }
	it { should respond_to(:resume) }
	it { should respond_to(:content) }
	it { should respond_to(:user_id) }
	it { should respond_to(:user) }
	its(:user) { should == user }
	it { should respond_to(:relationships) }
	it { should respond_to(:followers) }

	it { should be_valid }

	describe "accessible attributes" do
		it "should not allow acces to user_id" do
			expect do
				Publication.new(user_id: user.id)
			end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end

	describe "when user_id is not present" do
		before { @publication.user_id = nil }
		it { should_not be_valid }
	end

	describe "with blank title" do
		before { @publication.title = " " }
		it { should_not be_valid }
	end

	describe "with title that is too long" do
		before { @publication.title = "a" * 51 }
		it { should_not be_valid }
	end

	describe "with blank ptype" do
		before { @publication.ptype = " " }
		it { should_not be_valid }
	end

	describe "with ptype that is too long" do
		before { @publication.ptype = "a" * 51 }
		it { should_not be_valid }
	end

	describe "with blank nameofpublication" do
		before { @publication.nameofpublication = " " }
		it { should_not be_valid }
	end

	describe "with nameofpublication that is too long" do
		before { @publication.nameofpublication = "a" * 51 }
		it { should_not be_valid }
	end

	describe "with blank resume" do
		before { @publication.resume = " " }
		it { should_not be_valid }
	end

	describe "with resume that is too long" do
		before { @publication.resume = "a" * 141 }
		it { should_not be_valid }
	end

	describe "with blank content" do
		before { @publication.content = " " }
		it { should_not be_valid }
	end

end
