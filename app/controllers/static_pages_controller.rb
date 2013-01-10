class StaticPagesController < ApplicationController
  def home
  	if signed_in?
  		@publication = current_user.publications.build
  		@feed_items =current_user.feed.paginate(page: params[:page])
  	end
  end
end
