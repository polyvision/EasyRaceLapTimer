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

  it "idle mode for standard mode races" do
    SoundFileWorker.drain

    idled_race_session = RaceSession.create(title: 'Session',active: true,idle_time_in_seconds: 60) # 60 seconds idle time
    Timecop.travel(Time.now + 180.seconds)

    get 'update_race_session_idle_time'
    expect(response.status).to eq 200
    assert_equal 1, SoundFileWorker.jobs.size # should play a sound file
    SoundFileWorker.drain

    # let's start anothe race without explicitly creating a new one via the gui
    # the system should detect that the last race was a race with an idle time
    # it should start enother again
    expect(RaceSession::get_open_session().id).to eq (idled_race_session.id + 1)

    Timecop.return
  end

  it "idle mode for competition mode races" do
    SoundFileWorker.drain

    pilot_1 = Pilot.create(name: "Pilot 1", transponder_token: 1, quad:'ZMR')
    pilot_2 = Pilot.create(name: "Pilot 2", transponder_token: 2, quad:'ZMR')
    pilot_3 = Pilot.create(name: "Pilot 3", transponder_token: 3, quad:'ZMR')

    new_race_data = Hash.new
    new_race_data[:title] = "new competition race"
    new_race_data[:max_laps] = 5
    new_race_data[:idle_time_in_seconds] = 60
    new_race_data[:pilots] = Array.new
    new_race_data[:pilots] << {pilot_id: pilot_1.id, transponder_token: 10}
    new_race_data[:pilots] << {pilot_id: pilot_2.id, transponder_token: 20}
    new_race_data[:pilots] << {pilot_id: pilot_3.id, transponder_token: 30}


    post 'new_competition', data: new_race_data.to_json

    idled_race_session = RaceSession::get_open_session
    Timecop.travel(Time.now + 180.seconds)

    get 'update_race_session_idle_time'
    expect(response.status).to eq 200
    assert_equal 1, SoundFileWorker.jobs.size # should play a sound file
    SoundFileWorker.drain

    # let's start anothe race without explicitly creating a new one via the gui
    # the system should detect that the last race was a race with an idle time
    # it should start enother again
    expect(RaceSession::get_open_session().id).to eq (idled_race_session.id + 1)

    open_race_session = RaceSession::get_open_session()
    
    expect(open_race_session.race_attendees.count).to eq(3)

    expect(open_race_session.race_attendees.where(pilot_id: pilot_1.id).first.transponder_token).to eq("10")
    expect(open_race_session.race_attendees.where(pilot_id: pilot_2.id).first.transponder_token).to eq("20")
    expect(open_race_session.race_attendees.where(pilot_id: pilot_3.id).first.transponder_token).to eq("30")
    expect(open_race_session.active).to eq(true)

    Timecop.return
  end

  it "starting a race in competition mode" do

    pilot_1 = Pilot.create(name: "Pilot 1", transponder_token: 1, quad:'ZMR')
    pilot_2 = Pilot.create(name: "Pilot 2", transponder_token: 2, quad:'ZMR')
    pilot_3 = Pilot.create(name: "Pilot 3", transponder_token: 3, quad:'ZMR')

    new_race_data = Hash.new
    new_race_data[:title] = "new competition race"
    new_race_data[:max_laps] = 5
    new_race_data[:pilots] = Array.new
    new_race_data[:pilots] << {pilot_id: pilot_1.id, transponder_token: 10}
    new_race_data[:pilots] << {pilot_id: pilot_2.id, transponder_token: 20}
    new_race_data[:pilots] << {pilot_id: pilot_3.id, transponder_token: 30}


    post 'new_competition', data: new_race_data.to_json

    open_race_session = RaceSession::get_open_session

    expect(open_race_session.mode).to eq("competition")
    expect(open_race_session.title).to eq(new_race_data[:title])
    expect(open_race_session.max_laps).to eq(new_race_data[:max_laps])

    expect(open_race_session.race_attendees.count).to eq(3)

    expect(open_race_session.race_attendees.where(pilot_id: pilot_1.id).first.transponder_token).to eq("10")
    expect(open_race_session.race_attendees.where(pilot_id: pilot_2.id).first.transponder_token).to eq("20")
    expect(open_race_session.race_attendees.where(pilot_id: pilot_3.id).first.transponder_token).to eq("30")
    expect(open_race_session.active).to eq(true)
  end
end
