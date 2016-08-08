require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "shouldn't display unwanted flash messages on invalid login" do 
  	get login_path
  	assert_template "sessions/new"
  	post login_path, session: { 
  		email: "", 
  		password: ""}
  	assert_template "sessions/new"
  	assert_not flash.empty?
  	get home_path
  	assert flash.empty?
  end

  test "should be able to login with valid login & logout correctly after" do 
    # Logging in
    get login_path
    post login_path, session: {
      email: @user.email, 
      password: "password"
    }
    assert is_logged_in?
    assert_redirected_to home_path
    follow_redirect!

    # Logging out first time.
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to home_path

    # Logging out in a second window
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
  end

    test "login with remembering" do
      log_in_as(@user)
      assert_not cookies["remember_token"].nil? 
    end

    test "login without remembering" do
      log_in_as(@user, remember_me: 0)
      assert cookies["remember_token"].nil? 
    end


end
