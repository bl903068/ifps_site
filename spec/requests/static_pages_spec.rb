require 'spec_helper'

describe "Static pages" do
	describe "Home page" do
    	it "should have the h1 'Site IFPS'" do
      		visit '/static_pages/home'
      		page.should have_selector('h1', 'Site IFPS')
    	end

    	it "should have the base title" do
      		visit '/static_pages/home'
      		page.should have_selector('title', "Site IFPS")
    	end
    	it "should not have a custom page title" do
    		visit '/static_pages/home'
    		page.should_not have_selector('title', '| Home')
    	end
    end
end