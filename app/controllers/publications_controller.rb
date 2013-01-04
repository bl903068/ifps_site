class PublicationsController < ApplicationController
	
	def index
		@publications = Publication.paginate(page: params[:page])
	end

	def create
		unless signed_in?
        	store_location
        	redirect_to signin_url, notice: "Please sign in."
        else
			@publication = current_user.publications.build(params[:publication]) if signed_in?
			if @publication.save
				flash[:success] = "Publication created!"
				redirect_to root_url
			else
				render 'static_pages/home'
			end
		end
	end

	def destroy
		unless signed_in?
        	store_location
        	redirect_to signin_url, notice: "Please sign in."
        end
	end

	def show
		@publication = Publication.find(params[:id])
	end
end