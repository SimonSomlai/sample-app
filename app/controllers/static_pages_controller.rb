class StaticPagesController < ApplicationController
  before_action :setup

  def home
    @micropost = current_user.microposts.build if logged_in?
    @feed_items = current_user.feed.paginate(page: params[:page]) if logged_in?
  end

  def help

  end

  def about

  end

  def login

  end

  def signup

  end

  def contact

  end

  def setup
    @users = User.limit(10).order("id DESC")
  end

end
