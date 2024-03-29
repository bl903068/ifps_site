class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update]
  before_filter :correct_user, only: [:edit, :update]

  def show
  	@user = User.find(params[:id])
    @publications = @user.publications.paginate(page: params[:page])
  end

  def following
    @title = "Publications co-writted"
    @user = User.find(params[:id])
    @publications = @user.followed_publications.paginate(page: params[:page])
    render 'show_follow'
  end

  def new
  	@user = User.new
  end

  def create 
  	@user = User.new(params[:user])
  	if @user.save
  		flash[:success] = "Welcome to the Site IFPS"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  def edit
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  private
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
end