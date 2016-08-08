require 'test_helper'

def setup
# Global array of all deliveries, should be reset every time test is run.
  ActionMailer::Base.deliveries.clear
end

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "should not accept invalid signup information" do
    assert_no_difference "User.count" do
      post users_path, user: {
        name: "",
        email: "user@invalidformat",
        password: "foo",
        password_confirmation: "bar"
      }
    end
  end

  test "should accept valid signup information with account activation" do
    get signup_path
    ActionMailer::Base.deliveries.clear
    assert_difference "User.count", 1 do
      post users_path, user: {
        name: "Example User",
        email: "user@validformat.com",
        password: "password",
        password_confirmation: "password"
      }
    end
    # Check if mail has been send
    assert_equal 1, ActionMailer::Base.deliveries.size
    # Set user to the user hash that has been send
    user = assigns(:user)
    # Check if he isn't activated
    assert_not user.activated?
    # Check if the activation_digest has been created
    assert_not_nil user.activation_digest
    # Try logging in unactivated
    log_in_as(user)
    # Assert he isn't logged in
    assert_not is_logged_in?

    # Go to activation page with invalid token
    get edit_account_activation_path("invalid token")
    # Still not logged in
    assert_not is_logged_in?

    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: "wrong@email.com")
    assert_not is_logged_in?

    # Valid token, valid email
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template "users/show"
    assert is_logged_in?

  end
end
