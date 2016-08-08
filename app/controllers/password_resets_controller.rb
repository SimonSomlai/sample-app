class PasswordResetsController < ApplicationController
  before_action :valid_user?, only: [:edit, :update]

  def new

  end

  def create
    @user = User.find_by(email: params[:reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      redirect_to home_path
      flash[:info] = "Hey #{@user.name}, we've send your password reset link to #{@user.email}!"
    else
      flash[:danger] = "Sorry, there's no @user with that email"
      redirect_to home_path
    end
  end

  def edit
    if @user && !token_expired?
      return true
    else
      redirect_to home_path
      flash[:danger] = "Invalid email or expired token (tokens expire after 2 hours)"
    end
  end

  def update
    if !password_blank?
      if @user.update_attributes(user_params)
        flash[:success] = "Edited #{@user.name}'s password!"
        login @user
        redirect_to @user
        @user.update_attribute(:reset_digest, nil)
        @user.update_attribute(:reset_sent_at, nil)
      else
        render :edit
      end
    end
  end

  # Makes a hash
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def password_blank?
    params[:user][:password].blank?
  end

  def valid_user?
    @user = User.find_by(email: params[:email].downcase)
    if @user && @user.activated? && @user.authenticated?(:reset, params[:id])
      return true
    else
      redirect_to home_path
      flash[:warning] = "You're not authorized to do that"
    end
  end

  def token_expired?
    @user.reset_sent_at < 2.hours.ago
  end
end
