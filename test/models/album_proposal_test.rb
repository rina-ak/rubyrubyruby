require "test_helper"

class AlbumProposalTest < ActiveSupport::TestCase
  test "requires artist and title" do
    proposal = AlbumProposal.new
    assert_not proposal.valid?
    assert_includes proposal.errors[:artist], "can't be blank"
    assert_includes proposal.errors[:title], "can't be blank"
  end
end
