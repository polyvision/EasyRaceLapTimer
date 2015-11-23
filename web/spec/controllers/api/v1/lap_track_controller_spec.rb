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
  end
end
