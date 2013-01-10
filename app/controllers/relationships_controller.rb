class RelationshipsController < ApplicationController
  before_filter :signed_in_user

  def create
    @publication = Publication.find(params[:relationship][:followed_id])
    current_user.follow!(@publication)
    respond_to do |format|
      format.html { redirect_to @publication }
      format.js
    end
  end

  def destroy
    @publication = Relationship.find(params[:id]).followed
    current_user.unfollow!(@publication)
    respond_to do |format|
      format.html { redirect_to @publication }
      format.js
    end
  end
end