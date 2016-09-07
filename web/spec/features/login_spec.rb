require 'rails_helper'

RSpec.describe "the signin process", :type => :feature do
  before :each do
    User.create(:email => 'admin@easyracelaptimer.com', :password => 'password',password_confirmation: 'password')
    User.first.add_role(:admin)
  end

  it "race director safety" do
    visit '/race_director'
    expect(page).to have_content "Sorry, there's no race at present going on."
  end

  it "system configuration safety" do
    visit '/system'
    expect(page).to have_content "Sorry, there's no race at present going on."
  end

  it "login into system configuration" do
    visit '/users/sign_in'
    within("#new_user") do
      fill_in 'Email', :with => 'admin@easyracelaptimer.com'
      fill_in 'Password', :with => 'password'
    end
    click_button 'Sign in'
    expect(page).to have_content 'Signed in successfully'
  end

  it "start a standard race session" do
    visit '/users/sign_in'
    within("#new_user") do
      fill_in 'Email', :with => 'admin@easyracelaptimer.com'
      fill_in 'Password', :with => 'password'
    end
    click_button 'Sign in'
    expect(page).to have_content 'Signed in successfully'


    visit '/system'
    expect(page).to have_content 'Standard Race Tracking'
    fill_in 'race_session_title', :with => 'Standard'
    click_button 'Start Standard Race Session'

    #visit '/race_director'
    #open_race_session = RaceSession::get_open_session()
    #expect(open_race_session.title).to eq("Standard")
    #expect(page).to have_content 'Race Director' # we should land on the race director page
    #expect(page).to have_content 'Stop Race Session'

  end
end
