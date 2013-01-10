class PublicationsController < ApplicationController
	before_filter :signed_in_user, only: [:create, :destroy]
	before_filter :correct_user, only: :destroy

	def index
		@publications = Publication.paginate(page: params[:page])
	end

	def followers
    	@title = "Authors"
    	@publication = Publication.find(params[:id])
    	@users = @publication.followers.paginate(page: params[:page])
    	render 'show_follow'
  	end

	def create
		@publication = current_user.publications.build(params[:publication])
		if @publication.save
			flash[:success] = "Publication created!"
			redirect_to root_url
		else
			@feed_items = []
			render 'static_pages/home'
		end
	end

	def destroy
		@publication.destroy
		redirect_to root_url
	end

	def show
		@publication = Publication.find(params[:id])
	end

	private
		def correct_user
			@publication = current_user.publications.find_by_id(params[:id])
			redirect_to root_url if @publication.nil?
		end
end