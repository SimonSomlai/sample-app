require 'test_helper'

class MicropostsControllerTest < ActionController::TestCase
  def setup
    @micropost = microposts(:orange)
  end

  test "should redirect create when not logged in" do
    assert_no_difference "Micropost.count" do
      post :create, micropost: { content: "Lorem Ipsum"}
    end
    assert_redirected_to login_path
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference "Micropost.count" do
      post :destroy, id: @micropost
    end
    assert_redirected_to login_path
  end

  test "should redirect when user tries to delete micropost that isn't his own" do
    log_in_as(users(:michael))
    micropost = microposts(:ants)
    assert_no_difference "Micropost.count" do
      delete :destroy, id: micropost
    end
    assert_redirected_to home_path
  end
end
