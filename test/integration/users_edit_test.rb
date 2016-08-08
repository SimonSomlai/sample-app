require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "edits should be invalid with invalid info" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template "users/edit"
    patch user_path(@user), user: {
      name: "",
      email: "invalid@foo",
      password: "foo",
      password_confirmation: "bar"
    }
    assert_template "users/edit"
  end

  test "edits should be valid with valid info" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template "users/edit"
    patch user_path(@user), user: {
      name: "Michael",
      email: "michael@valid.com",
      password: "foobar",
      password_confirmation: "foobar"
    }
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, "Michael"
    assert_equal @user.email, "michael@valid.com"
  end

  test "user should be forwarded to intended destination on login" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
  end

end
