class PublicationsController < ApplicationController
	before_filter :signed_in_user

	def index
	end

	def create
		@publication = current_user.publications.build(params[:publication])
		if @publication.save
			flash[:success] = "Publication created!"
			redirect_to root_url
		else
			render 'static_pages/home'
		end
	end

	def destroy
	end

	def show
		@publication = Publication.find(params[:id])
	end
end