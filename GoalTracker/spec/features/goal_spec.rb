require 'spec_helper'

feature "user makes goals" do
  subject { page }
  let(:user) { FactoryGirl.create(:user) }

  before(:each) do
    login_user(user)
    visit user_goals_url(user)
    click_on "Create New Goal"
  end

  it { should have_content "Make a new goal" }

  it "should not allow a goal with no title" do
    fill_in 'Title', with: ""
    click_on "Make Goal"
    expect(page).to have_content "Title can't be blank"
  end

  it "can create a new goal with just a title" do
    fill_in 'Title', with: "Sleep more"
    click_on "Make Goal"
    expect(page).to have_content "Sleep more"
  end

  it "can create a new goal with a title and body" do
    fill_in 'Title', with: "Sleep more"
    fill_in 'Body', with: "I herby resolve to sleep more,  perhaps in the sunlight on the couch."
    click_on "Make Goal"
    expect(page).to have_content "Sleep more"
    expect(page).to have_content "I herby resolve to sleep more"
  end

  it "can create a new goal that is private" do
    fill_in 'Title', with: "Sleep more"
    check 'Private'
    click_on "Make Goal"
    expect(page).to have_content "Sleep more"
    expect(page).to have_content "This goal is private"
  end

end

feature "user sees all of their goals" do
  subject { page }
  let(:user) { FactoryGirl.create(:user) }


  it "can see multiple goals" do
    login_user(user)
    visit new_user_goal_url(user)
    fill_in 'Title', with: "Sleep more"
    click_on "Make Goal"
    visit new_user_goal_url(user)
    fill_in 'Title', with: "Also eat more"
    click_on "Make Goal"
    visit user_goals_url(user)
    expect(page).to have_content "Sleep more"
    expect(page).to have_content "Also eat more"
  end

end

feature "user can edit their goals" do
  subject { page }
  let(:user) { FactoryGirl.create(:user_with_goal) }

  it "has a link to the edit page" do
    login_user(user)
    visit goal_url(user.goals.first)
    expect(page).to have_content "Edit this goal"
  end

  describe "on the edit page" do

    before(:each) do
      login_user(user)
      visit goal_url(user.goals.first)
      click_link "Edit this goal"
    end

    it "has goal's information pre filled in" do
      title_text = user.goals.first.title
      body_text = user.goals.first.body
      find_field('Title').value.should eq title_text
      find_field('Body').value.should eq body_text
    end

    it "can edit a goal's title and body" do
      fill_in 'Title', with: "Sleep more"
      fill_in 'Body', with: "I hereby resolve to sleep more"
      click_on "Update Goal"

      expect(page).to have_content "Sleep more"
      expect(page).to have_content "I hereby resolve to sleep more"
    end

    it "cannot make a goal invalid" do
      fill_in 'Title', with: ""
      click_on "Update Goal"

      expect(page).to have_content "Title can't be blank"
    end

    it "can toggle privacy filter" do
      user2 = FactoryGirl.create(:user_with_private_goal)
      login_user(user2)
      visit goal_url(user2.goals.first)
      click_link "Edit this goal"
      uncheck "Private"
      click_on "Update Goal"
      expect(page).to have_content "This goal is public"
    end

  end

end

feature "user can destroy their goals" do
  subject { page }
  let(:user) { FactoryGirl.create(:user_with_goal) }

  before(:each) do
    login_user(user)
    visit goal_url(user.goals.first)
  end

  it "has a button to delete goal" do
    expect(page).to have_button "Delete this goal"
  end

  it "can delete the goal" do
    title_text = user.goals.first.title
    click_button "Delete this goal"
    expect(page).to_not have_content title_text
  end

end

feature "users can't see other user's private goals" do
  let(:user) { FactoryGirl.create(:user_with_private_goal) }
  let(:user2) { FactoryGirl.create(:user_with_goal) }

  it "can't see another user's private goal" do
    login_user(user2)
    visit user_goals_url(user)
    title_text = user.goals.first.title
    expect(page).to_not have_content title_text
  end

  it "can see another user's public goal" do
    login_user(user)
    visit user_goals_url(user2)
    title_text = user2.goals.first.title
    expect(page).to have_content title_text
  end
end

feature "users can mark goals as completed" do
  let(:user) { FactoryGirl.create(:user_with_private_goal) }

  before(:each) do
    login_user(user)
    visit goal_url(user.goals.first)
  end

  it "should have a button to mark as completed" do
    expect(page).to have_button("Mark as completed")
  end

  it "clicking the button should mark goal as completed" do
    click_button "Mark as completed"
    expect(page).to_not have_button("Mark as completed")
    expect(page).to have_content("Congratulations! You've completed this goal")
  end

  describe "once marked as completed" do
    before(:each) do
      login_user(user)
      visit goal_url(user.goals.first)
      click_button "Mark as completed"
    end

    it "should have a button to re-open a goal" do
      expect(page).to have_button("Re-activate this goal")
    end

    it "re-opening a goal should make it uncompleted" do
      click_button "Re-activate this goal"
      expect(page).to have_button("Mark as completed")
      expect(page).to_not have_button("Re-activate this goal")
    end

    it "shows as completed on goals index" do
      visit user_goals_url(user)
      expect(page).to have_content("-- Completed!")
    end
  end
end