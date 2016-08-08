class UsersController < ApplicationController
  include MicropostsHelper
  include UsersHelper
  before_action :logged_in_user?, only: [:edit, :update, :index, :destroy, :following, :followers]
  before_action :is_correct_user?, only: [:edit, :update]
  before_action :is_admin?, only: [:destroy]

  def following
    @user = current_user
    @following = current_user.following.paginate(page: params[:page])
  end

  def followers
    @user = current_user
    @followers = current_user.followers.paginate(page: params[:page])
  end

  def index
    @users = User.where(activated: true).paginate(page: params[:page]).order("id DESC")
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # When saving, send a account activation mail 
      @user.send_activation_email
      flash[:info] = "Hey #{@user.name}, please check your email to activate your account"
      redirect_to home_path
    else
      render :new
      flash[:danger] = "An error occured"
    end
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    @micropost = @user.microposts.build
  end

  def edit

  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Edited #{@user.name}'s profile!"
      login @user
      redirect_to @user
    else
      render :edit
      flash[:danger] = "An error occured"
    end
  end

  def destroy
    @user = User.find(params[:id])
    name = @user.name
    @user.destroy
    redirect_to users_path
    flash[:success] = "#{name} successfully deleted!"
  end

end
