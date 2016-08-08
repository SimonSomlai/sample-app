require 'test_helper'

class PasswordResetTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:simon)
    @user.reset_digest = nil
    ActionMailer::Base.deliveries.clear
  end

  test "should normally load the password reset form & update digest when submitted with valid email + send email after & go through nicely on through" do
    # Valid format
    get new_password_reset_path
    assert_template "password_resets/new"
    post password_resets_path, reset: {
    email: @user.email  }
    @user.reload
    @user = assigns(:user)
    assert_not @user.password_digest.nil?
    assert_redirected_to home_path
    follow_redirect!
    assert_not flash.empty?
    assert_equal 1, ActionMailer::Base.deliveries.size

    # Clicking reset link with valid info
    get edit_password_reset_path(@user.reset_token, email: @user.email)
    assert "password_resets/edit"
    patch password_reset_path(@user.reset_token),
      email: @user.email,
    user: {
      password: "password",
      password_confirmation: "password"
    }
    assert_not flash.empty?
    assert is_logged_in?
    assert_redirected_to @user
  end

  test "should give errors when trying to change password with invalid info" do# Clicking reset link with valid info
    # Valid key creation
    get new_password_reset_path
    assert_template "password_resets/new"
    post password_resets_path, reset: {
    email: @user.email  }
    @user.reload
    @user = assigns(:user)
    assert_not @user.password_digest.nil?
    assert_redirected_to home_path
    follow_redirect!
    assert_not flash.empty?
    assert_equal 1, ActionMailer::Base.deliveries.size

    # Wrong token
    get edit_password_reset_path("wrong-token", email: @user.email)
    assert_redirected_to home_path
    assert_not flash.empty?
    # Wrong email
    get edit_password_reset_path(@user.reset_token, email: "wrong@email.com")
    assert_redirected_to home_path
    assert_not flash.empty?

    # Right email Right token, bad new password
    get edit_password_reset_path(@user.reset_token, email: @user.email)
    assert "password_resets/edit"
    patch password_reset_path(@user.reset_token),
      email: @user.email,
    user: {
      password: "foo",
      password_confirmation: "bar"
    }
    assert "password_resets/edit"
    assert_not is_logged_in?
  end

  test "should give an error when password reset form is submitted with unregistered email" do
    # Invalid format
    get new_password_reset_path
    assert_template "password_resets/new"
    post password_resets_path, reset: {
    email: "inavlid@email.com"  }
    @user.reload
    assert @user.reset_digest.nil?
    assert_redirected_to home_path
    follow_redirect!
    assert_not flash.empty?
    assert_equal 0, ActionMailer::Base.deliveries.size
    # Invalid token
  end
end
