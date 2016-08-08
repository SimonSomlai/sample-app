require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @simon = users(:simon)
    @user = users(:michael)
  end

  test "should paginate" do
    log_in_as(@user)
    get users_path
    assert_template "users/index"
    assert_select "div.pagination"
    User.where(activated: true).paginate(page: 1).order("id DESC").each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
    end
  end

  test "should correctly show index when admin" do
    log_in_as(@simon)
    get users_path
    assert_template "users/index"
    assert_select "div.pagination"
    first_page_of_users = User.where(activated: true).paginate(page: 1).order("id DESC")
    first_page_of_users.each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
      unless user == @simon
        assert_select "a[href=?]", user_path(user), text: "Delete User", method: "delete"
      end
    end
  end

  test "shouldn't show delete links when not admin" do
    log_in_as(@user)
    get users_path
    assert_select "a", text: "Delete User", count: 0
  end
end
