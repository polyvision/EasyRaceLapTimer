require 'rails_helper'

RSpec.describe Api::V1::LapTrackController, :type => :controller do
  describe "track lap" do
    before(:each) do
      ConfigValue::set_value("lap_timeout_in_seconds","4")
      ConfigValue::set_value("lap_max_lap_time_in_seconds","60")
    end

    it "no current race session" do
      post 'create'
      expect(response.status).to eq 409
    end

    it "tracking a normal lap" do
      pilot = Pilot.create(name: "Test", transponder_token: 63, quad:'ZMR')
      race_session = RaceSession.create(title: 'Session',active: true)

      post 'create',transponder_token: pilot.transponder_token, lap_time_in_ms: 10000

      expect(response.status).to eq 200
    end

    it "check lap tracking timeout" do
      ConfigValue::set_value("lap_timeout_in_seconds",4)
      pilot = Pilot.create(name: "Test", transponder_token: 63, quad:'ZMR')
      race_session = RaceSession.create(title: 'Session',active: true)

      # first lap
      post 'create',transponder_token: pilot.transponder_token, lap_time_in_ms: 10000
      expect(response.status).to eq 200
      race_session.reload
      expect(race_session.pilot_race_laps.count).to eq(1)

      # too fast request
      post 'create',transponder_token: pilot.transponder_token, lap_time_in_ms: 10000
      race_session.reload
      expect(race_session.pilot_race_laps.count).to eq(1)
      expect(response.status).to eq 403

      # now it should work again
      Timecop.travel(Time.now + 4.seconds)
      post 'create',transponder_token: pilot.transponder_token, lap_time_in_ms: 10000
      race_session.reload
      expect(race_session.pilot_race_laps.count).to eq(2)
      expect(response.status).to eq 200
    end

    it "check max lap time tracking" do
      ConfigValue::set_value("lap_timeout_in_seconds",4)
      pilot = Pilot.create(name: "Test", transponder_token: 63, quad:'ZMR')
      race_session = RaceSession.create(title: 'Session',active: true)

      # first lap
      post 'create',transponder_token: pilot.transponder_token, lap_time_in_ms: 60000
      expect(response.status).to eq 403
      race_session.reload
      expect(race_session.pilot_race_laps.count).to eq(0)


      # now it should work again
      post 'create',transponder_token: pilot.transponder_token, lap_time_in_ms: 59999
      race_session.reload
      expect(race_session.pilot_race_laps.count).to eq(1)
      expect(response.status).to eq 200
    end

    it "simulate a race in competition mode" ,:type => :request do
      ConfigValue::set_value("lap_timeout_in_seconds",4)
      ConfigValue::set_value("lap_max_lap_time_in_seconds",60)

      Timecop.return
      # setting up the race data
      pilot_1 = Pilot.create(name: "Pilot 1", transponder_token: 1, quad:'ZMR')
      pilot_2 = Pilot.create(name: "Pilot 2", transponder_token: 2, quad:'ZMR')
      pilot_3 = Pilot.create(name: "Pilot 3", transponder_token: 3, quad:'ZMR')

      new_race_data = Hash.new
      new_race_data[:title] = "new competition race"
      new_race_data[:max_laps] = 3
      new_race_data[:pilots] = Array.new
      new_race_data[:pilots] << {pilot_id: pilot_1.id, transponder_token: 10}
      new_race_data[:pilots] << {pilot_id: pilot_2.id, transponder_token: 20}
      new_race_data[:pilots] << {pilot_id: pilot_3.id, transponder_token: 30}


      post '/api/v1/race_session/new_competition', data: new_race_data.to_json

      open_race_session = RaceSession::get_open_session
      expect(open_race_session.mode).to eq("competition")
      expect(open_race_session.active).to eq(true)


      # first round
      post '/api/v1/lap_track',transponder_token: 10, lap_time_in_ms: 10000
      expect(response.status).to eq 200

      Timecop.travel(Time.now + 1.seconds)
      post '/api/v1/lap_track',transponder_token: 20, lap_time_in_ms: 11000
      expect(response.status).to eq 200

      Timecop.travel(Time.now + 2.seconds)
      post '/api/v1/lap_track',transponder_token: 30, lap_time_in_ms: 12000
      expect(response.status).to eq 200

      open_race_session.reload
      expect(open_race_session.pilot_race_laps.count).to eq(3)

      get '/api/v1/monitor'
      expect(response.status).to eq 200
      json_monitor_data = JSON::parse(response.body)

      expect(json_monitor_data['data'][0]['pilot']['name']).to eq("Pilot 1")
      expect(json_monitor_data['data'][1]['pilot']['name']).to eq("Pilot 2")
      expect(json_monitor_data['data'][2]['pilot']['name']).to eq("Pilot 3")

      # second round
      Timecop.travel(Time.now + 11.seconds)
      post '/api/v1/lap_track',transponder_token: 30, lap_time_in_ms: 10000
      expect(response.status).to eq 200

      Timecop.travel(Time.now + 12.seconds)
      post '/api/v1/lap_track',transponder_token: 20, lap_time_in_ms: 11000
      expect(response.status).to eq 200

      Timecop.travel(Time.now + 13.seconds)
      post '/api/v1/lap_track',transponder_token: 10, lap_time_in_ms: 12000
      expect(response.status).to eq 200

      open_race_session.reload
      expect(open_race_session.pilot_race_laps.count).to eq(6)

      get '/api/v1/monitor'
      expect(response.status).to eq 200
      json_monitor_data = JSON::parse(response.body)

      expect(json_monitor_data['data'][0]['pilot']['name']).to eq("Pilot 3")
      expect(json_monitor_data['data'][1]['pilot']['name']).to eq("Pilot 2")
      expect(json_monitor_data['data'][2]['pilot']['name']).to eq("Pilot 1")

      # third round
      Timecop.travel(Time.now + 11.seconds)
      post '/api/v1/lap_track',transponder_token: 20, lap_time_in_ms: 11000
      expect(response.status).to eq 200

      Timecop.travel(Time.now + 12.seconds)
      post '/api/v1/lap_track',transponder_token: 30, lap_time_in_ms: 12000
      expect(response.status).to eq 200

      Timecop.travel(Time.now + 30.seconds)
      post '/api/v1/lap_track',transponder_token: 10, lap_time_in_ms: 10000
      expect(response.status).to eq 200

      get '/api/v1/monitor'
      expect(response.status).to eq 200
      json_monitor_data = JSON::parse(response.body)

      expect(json_monitor_data['data'][0]['pilot']['name']).to eq("Pilot 2")
      expect(json_monitor_data['data'][1]['pilot']['name']).to eq("Pilot 3")
      expect(json_monitor_data['data'][2]['pilot']['name']).to eq("Pilot 1")

      # just one more round to check if more laps would be counted
      Timecop.travel(Time.now + 11.seconds)
      post '/api/v1/lap_track',transponder_token: 20, lap_time_in_ms: 11000
      expect(response.status).to eq 403

      open_race_session.reload
      expect(open_race_session.pilot_race_laps.count).to eq(9)
    end
  end
end
