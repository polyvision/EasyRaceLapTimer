require 'rails_helper'

RSpec.describe "RaceEventBuilderAdapter", type: :request do
  before(:each) do
    ConfigValue::set_value("time_between_lap_track_requests_in_seconds","4")
    ConfigValue::set_value("lap_max_lap_time_in_seconds","60")
    ConfigValue::set_value("lap_min_lap_time_in_seconds","4")
    ConfigValue::set_value("udp_broadcast_address","127.0.0.1")
  end

  it "test building groups",:type => :request do
    for i in 1..7 do
      Pilot.create(name: "Pilot #{i}", transponder_token: "VTX#{i}", quad:'ZMR')
    end

    expect(Pilot.all.count).to eq(7)

    race_event = RaceEvent.create(title: 'Test',number_of_pilots_per_group: 3, number_of_heats: 3)
    builder = RaceEventBuilderAdapter.new(race_event)
    builder.build

    # 7 pilots, 3 pilots per group, there should be 6 groups
    expect(RaceEventGroup.all.count).to eq(3)
    expect(RaceEventGroupEntry.all.count).to eq(7)

    # lets start the next head, we're in "stay" mode

    post '/api/v1/race_event/next_heat'
    expect(response.status).to eq 200

    race_event.reload
    expect(race_event.current_heat).to eq(2)

    expect(RaceEventGroupEntry.all.count).to eq(14)
    expect(RaceEventGroup.where(heat_done:true).count).to eq(3)
    expect(RaceEventGroup.where(heat_done:false).count).to eq(3)
    expect(RaceEventGroup.all.count).to eq(6)
    expect(RaceEventGroup.where(heat_no: 1).count).to eq(3)
    expect(RaceEventGroup.where(heat_no: 2).count).to eq(3)
  end
end
