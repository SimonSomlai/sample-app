require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "simon", email: "simon_somlai@hotmail.com", password: "password", password_confirmation: "password")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "    "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "    "
    assert_not @user.valid?
  end

  test "email adresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    # If invalid, pass the test
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, "")
  end

  test "posts should be destroyed when user is destroyed" do
    @user.save
    @user.microposts.create(content: "this is the content")
    @micropost = @user.microposts.first
    assert_not_nil @micropost
    assert_difference "Micropost.count", -1 do
      @user.destroy
    end
  end

  test "feed should have the right posts" do
    michael = users(:michael)
    timmy = users(:timmy)
    lana = users(:lana)
    # Make sure michaels feed includes lana's posts
    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end

    # Make sure michaels feed includes his own posts
    michael.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end

    # Make sure michaels feed doesn't include timmies posts
    timmy.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end

  end

end
