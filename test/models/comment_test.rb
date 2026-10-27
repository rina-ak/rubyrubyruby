require "test_helper"

class CommentTest < ActiveSupport::TestCase
  test "requires body" do
    comment = Comment.new(album: albums(:one), user: users(:regular), body: "")
    assert_not comment.valid?
    assert_includes comment.errors[:body], "can't be blank"
  end
end
