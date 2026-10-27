require "test_helper"

class AdminControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @user = users(:regular)
  end

  test "guest cannot open admin" do
    get admin_root_url
    assert_redirected_to new_user_session_url
  end

  test "regular user cannot open admin" do
    sign_in @user
    get admin_root_url
    assert_redirected_to root_path
  end

  test "admin sees proposals" do
    AlbumProposal.create!(artist: "Radiohead", title: "In Rainbows", notes: "визуал")
    sign_in @admin
    get admin_album_proposals_url
    assert_response :success
    assert_select "h3", text: "In Rainbows"
  end

  test "admin can delete a proposal" do
    proposal = AlbumProposal.create!(artist: "Radiohead", title: "In Rainbows")
    sign_in @admin
    assert_difference("AlbumProposal.count", -1) do
      delete admin_album_proposal_url(proposal)
    end
    assert_redirected_to admin_album_proposals_url
  end
end
