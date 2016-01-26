require 'rails_helper'

RSpec.describe "the signin process", :type => :feature do
  before :each do
    User.create(:email => 'admin@easyracelaptimer.com', :password => 'password',password_confirmation: 'password')
  end

  it "race director safety" do
    visit '/race_director'
    expect(page).to have_content 'Sign in'
  end

  it "system configuration safety" do
    visit '/system'
    expect(page).to have_content 'Sign in'
  end

  it "login into system configuration" do
    visit '/system'
    within("#new_user") do
      fill_in 'Email', :with => 'admin@easyracelaptimer.com'
      fill_in 'Password', :with => 'password'
    end
    click_button 'Sign in'
    expect(page).to have_content 'Signed in successfully'
  end

  it "start a standard race session" do
    visit '/system'
    within("#new_user") do
      fill_in 'Email', :with => 'admin@easyracelaptimer.com'
      fill_in 'Password', :with => 'password'
    end
    click_button 'Sign in'
    expect(page).to have_content 'Signed in successfully'

    fill_in 'race_session_title', :with => 'Standard'
    click_button 'Start Standard Race Session'

    open_race_session = RaceSession::get_open_session()
    expect(open_race_session.title).to eq("Standard")
    expect(page).to have_content 'Stop Race Session'
  end
end
