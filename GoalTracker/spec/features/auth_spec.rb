
require 'spec_helper'

feature "the signup process" do
  subject { page }

  before(:each) do
    visit new_user_url
  end

  it "has a new user page" do
    expect(page).to have_content "Create user"
  end

  feature "requires username and password" do

    before(:each) do
      visit new_user_url
    end

    it "requires a username" do
      fill_in 'Username', with: ""
      fill_in 'Password', with: "meowmeow"
      click_on "Create User"
      expect(page).to have_content "Username can't be blank"
    end

    it "requires a Password of at least 6 characters" do
      fill_in 'Username', with: "Breakfast"
      fill_in 'Password', with: "meow"
      click_on "Create User"
      expect(page).to have_content "Password is too short (minimum is 6 characters)"
    end

  end

  feature "signing up a user" do
    before(:each) do
      visit new_user_url
      fill_in 'Username', with: "Breakfast"
      fill_in 'Password', with: "meowmeow"
      click_on "Create User"
    end

    it do
      should have_content("Breakfast") do
       with_button("Sign Out")
      end
    end

  end

end

feature "logging in" do
  subject { page }

  let(:user){ User.create(:username => "Breakfast", :password => "meowmeow") }

  before(:each) do
    visit new_user_url
    fill_in 'Username', with: "Breakfast"
    fill_in 'Password', with: "meowmeow"
    click_on "Create User"

    visit new_session_url
    fill_in 'Username', with: "Breakfast"
    fill_in 'Password', with: "meowmeow"
    click_on "Log In"

  end


  it do
    should have_content("Breakfast") do
     with_button("Sign Out")
    end
  end


end

feature "logging out" do
  subject { page }
  before(:each) do
    visit new_session_url
  end

  it { should have_content("Sign Up") }
  it { should have_content("Sign In") }
  it { should_not have_content("Sign Out")}


  feature "once logged in" do
    let(:user){ User.create(:username => "Breakfast", :password => "meowmeow") }
    before(:each) do
      visit new_user_url
      fill_in 'Username', with: "Breakfast"
      fill_in 'Password', with: "meowmeow"
      click_on "Create User"

      visit new_session_url
      fill_in 'Username', with: "Breakfast"
      fill_in 'Password', with: "meowmeow"
      click_on "Log In"
      click_on "Sign Out"
    end

    it { should_not have_content("Breakfast") }
    it { should have_content("Sign In") }
    it { should have_content("Sign Up") }
  end
end
