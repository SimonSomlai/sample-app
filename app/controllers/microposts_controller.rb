class MicropostsController < ApplicationController
  include MicropostsHelper
  before_action :logged_in_user?, only: [:create, :destroy]
  before_action :correct_user?, only: [:destroy]

  def create
    @user = User.find_by(id: params[:user])
    @micropost = @user.microposts.build(micropost_params)
    if @micropost.save
      url = request.referrer.nil? ? home_path : request.referrer
      if url == "http://localhost:3000/users/#{@user.id}"
        redirect_to user_path(user)
        flash[:success] = "Post successfully created #{@user.name}!"
      else
        flash[:success] = "Post successfully created #{@user.name}!"
        redirect_to home_path
      end
    else
      if request.referrer == "http://localhost:3000/users/#{@user.id}"
        @microposts = @user.microposts.paginate(page: params[:page])
        render "users/show"
      else
        @feed_items = @user.microposts.paginate(page: params[:page])
        render "static_pages/home"
      end
    end
  end

  def destroy
    @micropost = Micropost.find_by(id: params[:id])
    @micropost.destroy
    redirect_to user_path(@user)
    flash[:success] = "Post successfully deleted #{@user.name}!"
  end

  def correct_user?
    @user = User.find_by(id: params[:user])
    redirect_to home_path unless current_user == @user
  end
end
