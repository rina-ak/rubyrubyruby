require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @album = albums(:one)
    @comment = comments(:one)
    @user = users(:regular)
    @admin = users(:admin)
  end

  test "guest cannot create comment" do
    assert_no_difference("Comment.count") do
      post album_comments_url(@album), params: { comment: { body: "Hello" } }
    end
    assert_redirected_to new_user_session_url
  end

  test "signed in user can create comment" do
    sign_in @user
    assert_difference("Comment.count") do
      post album_comments_url(@album), params: { comment: { body: "Great album" } }
    end
    assert_redirected_to "#{album_url(@album)}#discussion"
  end

  test "user can destroy own comment" do
    sign_in @user
    assert_difference("Comment.count", -1) do
      delete album_comment_url(@album, @comment)
    end
    assert_redirected_to "#{album_url(@album)}#discussion"
  end

  test "user cannot destroy someone else's comment" do
    sign_in @user
    other = comments(:two)
    assert_no_difference("Comment.count") do
      delete album_comment_url(other.album, other)
    end
    assert_redirected_to root_path
  end

  test "admin can destroy any comment" do
    sign_in @admin
    assert_difference("Comment.count", -1) do
      delete album_comment_url(@album, @comment)
    end
    assert_redirected_to "#{album_url(@album)}#discussion"
  end
end
