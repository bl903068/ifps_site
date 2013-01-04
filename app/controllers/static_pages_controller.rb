class StaticPagesController < ApplicationController
  def home
  	@publication = current_user.publications.build if signed_in?
  end
end
