require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "micropost interface test" do
    log_in_as(@user)
    get home_path
    assert_select "div.pagination"
    # Invalid submission
    assert_no_difference "Micropost.count" do
      post microposts_path(user: @user.id), micropost: {
        content: ""
      }
    end
    assert_select "div#error_explanation"
    # valid submission
    assert_difference "Micropost.count", 1 do
      post microposts_path(user: @user.id), micropost: {
        content: "new post content"
      }
    end
    assert_redirected_to home_path
    follow_redirect!
    assert_match "new post content", response.body

    # valid deletion
    get user_path(@user)
    assert_select "a", text: "Delete post"
    @micropost1 = @user.microposts.paginate(page: 1).first
    assert_difference "Micropost.count", -1 do
      delete micropost_path(@micropost1, user: @micropost1.user)
    end
    assert_redirected_to user_path(@user)
    # visit another user
    get user_path(users(:lana))
    assert_select "a", text: "Delete post", count: 0
  end
end
