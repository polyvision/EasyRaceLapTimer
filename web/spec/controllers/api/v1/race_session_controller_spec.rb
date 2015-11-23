require 'rails_helper'

RSpec.describe Api::V1::RaceSessionController, type: :controller do
  it "starting a new race" do
    post 'new'
    expect(response.status).to eq 200
  end

  it "starting a new race, stopping session before" do
    old_race_session = RaceSession.create(title: 'Session',active: true)
    post 'new'
    expect(response.status).to eq 200

    expect(RaceSession::get_open_session.id).not_to eq(old_race_session.id)

    json_data = JSON::parse(response.body)
    expect(json_data['id']).to eq(RaceSession::get_open_session.id)
  end
end
