class RelationshipsController < ApplicationController
  before_filter :logged_in_user?

  def create
    @followed = User.find_by(id: params[:followed_id])
    current_user.follow!(@followed)
    respond_to do |format|
      @user = @followed 
      format.html { redirect_to user_path(@followed) } 
      format.js
        # flash[:success] = "Succesfully followed #{@followed.name}!",
    end
  end

  def destroy
    @followed = Relationship.find_by(id: params[:id]).followed
    current_user.unfollow!(@followed)
    respond_to do |format|
      @user = @followed 
      format.html { redirect_to user_path(@followed)}
      format.js
        # flash[:success] = "Stopped following #{@followed.name} successfully!"
    end
  end
end
