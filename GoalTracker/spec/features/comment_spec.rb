require 'spec_helper'
require 'debugger'

feature 'user can add comment to another user' do
  let(:user1) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user_with_goal) }

  before(:each) do
    log_in(user1)
    visit user_url(user2)
  end

  it "should have add comment text" do
    expect(page).to have_content("Comment:")
    expect(page).to have_content("Comments")
  end

  it "can add a comment to a user" do
    fill_in "Comment:", with: "You are the best cat"
    click_on "Add Comment"
    expect(page).to have_content("You are the best cat")
  end
end

feature 'user can add comment to another users public goal' do
  let(:user1) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user_with_goal) }

  before(:each) do
    log_in(user1)
    visit goal_url(user2.goals.first)
  end

  it "should have add comment text" do
    expect(page).to have_content("Comment:")
    expect(page).to have_content("Comments")
  end

  it "can add a comment to a user" do
    fill_in "Comment:", with: "You are the best cat"
    click_on "Add Comment"
    expect(page).to have_content("You are the best cat")
  end
end

# feature 'user can comment on their own goal' do
#
# end
#
# feature 'user can remove comment they make on another user ' do
#
# end
#
# feature 'user can remove their own comments another user\'s goal' do
#
# end
#
# feature 'user can\'t remove another user\'s comment on another user\'s goal' do
#
# end
#
# feature 'user can remove another user\'s comment on their own goal and self' do
#
# end