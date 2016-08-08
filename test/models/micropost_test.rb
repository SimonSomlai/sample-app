require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:simon)
    @micropost = @user.microposts.build(content: "this is the content", user_id: @user.id)
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "user ID should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content should be present" do
    @micropost.content = nil
    assert_not @micropost.valid?
  end

  test "content should be at most be 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  test "standard table should be sorted by date (recent first)" do
    @micropost = microposts(:most_recent)
    assert Micropost.first == @micropost
  end
end
