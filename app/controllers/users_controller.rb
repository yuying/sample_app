class UsersController < ApplicationController
  before_filter :authenticate,   :except => [:show, :new, :create]
  before_filter :correct_user,   :only => [:edit, :update]
  before_filter :admin_user,     :only => :destroy
  before_filter :signed_in_user, :only => [:new, :create]

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = @user.name
  end 

  def new
   @user = User.new 
   @title = "Sign up"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @user.password = nil
      @user.password_confirmation = nil
      @title = "Sign up"
      render 'new'  
    end
  end

  def edit
    @user = User.find(params[:id])
    @title = "Edit user"
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end
  
  def destroy
    @user = User.find(params[:id])
    if  current_user == @user
      flash[:error] = "You cannot delete yourself!"
    else
      @user.destroy
      flash[:success] = "User destroyed."
    end
  redirect_to users_path
  end

  def signed_in_user
    if signed_in?
      flash[:info] = "You already signed in, and can not create new account."
      redirect_to(root_path)
    end
  end

  def following 
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
