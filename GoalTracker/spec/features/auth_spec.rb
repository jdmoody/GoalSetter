require 'spec_helper'

feature "the signup process" do

  before(:each) do
    visit new_user_url
  end

  it "has a new user page" do
    expect(page).to have_content "New user"
  end

  feature "requires username and password" do

    before(:each) do
      visit new_user_url
    end

    it "requires a username" do
      fill_in 'username', with: ""
      fill_in 'password', with: "meowmeow"
      click_on "Create User"
      expect(page).to have_content "Username can't be blank"
    end

    it "requires a password" do
      fill_in 'username', with: "Breakfast"
      fill_in 'password', with: ""
      click_on "Create User"
      expect(page).to have_content "Password can't be blank"
    end

    it "requires a password of at least 6 characters" do
      fill_in 'username', with: "Breakfast"
      fill_in 'password', with: "meow"
      click_on "Create User"
      expect(page).to have_content "Password must be at least 6 characters"
    end

  end

  feature "signing up a user" do
    before(:each) do
      visit new_user_url
      fill_in 'username', with: "Breakfast"
      fill_in 'password', with: "meowmeow"
      click_on "Create User"
    end

    it { should have_content("Breakfast") }
    it { should have_content("Sign Out") }

  end

end

feature "logging in" do

  let(:user){ User.create(:username => "Breakfast", :password => "meowmeow") }
  before(:each) do
    visit new_session_url
    fill_in 'username', with: "Breakfast"
    fill_in 'password', with: "meowmeow"
    click_on "Sign In"
  end


  it { should have_content("Breakfast") }
  it { should have_content("Sign Out") }


end

feature "logging out" do
  it { should have_content("Sign Up") }
  it { should have_content("Sign In") }
  it { should_not have_content("Sign Out")}


  feature "once logged in" do
    let(:user){ User.create(:username => "Breakfast", :password => "meowmeow") }
    before(:each) do
      visit new_session_url
      fill_in 'username', with: "Breakfast"
      fill_in 'password', with: "meowmeow"
      click_on "Sign In"
      click_on "Sign Out"
    end

    it { should_not have_content("Breakfast") }
    it { should have_content("Sign In") }
    it { should have_content("Sign Up") }
  end
end
