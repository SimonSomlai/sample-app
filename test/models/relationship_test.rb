require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  def setup
    @relationship = Relationship.new(follower_id: 1, followed_id: 2)
  end

  test "relationship should be valid" do
    assert @relationship.valid?
  end

  test "should require a follower_id" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  test "should require a followed_id" do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end

  test "should follow and unfollow correctly" do
    michael = users(:michael)
    simon = users(:simon)
    assert_not simon.following?(michael)
    simon.follow!(michael)
    assert simon.following?(michael)
    simon.unfollow!(michael)
    assert_not simon.following?(michael)
  end
end