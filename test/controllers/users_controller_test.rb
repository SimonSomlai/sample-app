require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @user = users(:michael)
    @simon = users(:simon)
  end

  test "should redirect on index, edit & update when not logged in" do
    # Get edit
    get :edit, id: @user
    assert_redirected_to login_path
    assert_not flash.empty?

    # Trying to patch
    patch :update, id: @user, user: {
      name: @user.name,
      email: @user.email
    }
    assert_redirected_to login_path
    assert_not flash.empty?

    # Get index
    get :index
    assert_redirected_to login_path
  end

  test "should redirect to home when accessing edits or updating profiles of other users" do
    # Get edit
    log_in_as(@user)
    get :edit, id: @simon
    assert_redirected_to home_path
    assert_not flash.empty?

    # Trying to patch
    patch :update, id: @simon, user: {
      name: @simon.name,
      email: @simon.email
    }
    assert_redirected_to home_path
    assert_not flash.empty?
  end

  test "shouldn't be able to update admin attribute through patch request" do
    patch :update, id: @user, user: {
      name: @user.name,
      email: @user.email,
      admin: true
    }
    assert @user.admin? == false
  end

  test "shouldn't be able to destroy users and be redirected to login page when not logged in" do
    assert_no_difference "User.count" do
      delete :destroy, id: @user
    end
    assert_redirected_to login_path
  end

  test "shouldn't be able to destroy users when not logged in as admin" do
    log_in_as(@user)
    assert_no_difference "User.count" do
      delete :destroy, id: @user
    end
    assert_redirected_to home_path
    assert_not flash.empty?
  end

  test "should be able to destroy users when logged in as admin" do
    log_in_as(@simon)
    assert_difference "User.count", -1 do
      delete :destroy, id: @user
    end
    assert_redirected_to users_path
    assert_not flash.empty?
  end

  test "should redirect following when not logged_in" do
    get :following, id: @user
    assert_redirected_to login_path
  end

  test "should redirect followers when not logged_in" do
    get :followers, id: @user
    assert_redirected_to login_path
  end
end
