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

  it "test building groups via combine_fastest_pilots_via_pos",:type => :request do
    RaceSession::stop_open_session
    pilots = Array.new
    for i in 1..5 do
      pilots << Pilot.create(name: "Pilot #{i}", transponder_token: "VTX_#{i}", quad:'ZMR')
    end

    race_event = RaceEvent.create(title: 'Test',number_of_pilots_per_group: 3, number_of_heats: 3,next_heat_grouping_mode: "combine_fastest_pilots_via_pos")
    builder = RaceEventBuilderAdapter.new(race_event)
    builder.build

    expect(RaceEventGroup.all.count).to eq(2)
    expect(RaceEventGroupEntry.all.count).to eq(5)

    adapter = RaceEventRaceSessionBuilderAdapter.new(race_event)
    expect(adapter.perform).to eq(true)

    race_session = RaceSession::get_open_session
    expect(race_session).to be_truthy

    expect(race_session.race_attendees.count).to eq(3) # max 3 pilots

    first_race_group = race_event.current_group
    expect(first_race_group.group_no).to eq(1)

    pilots_for_testing_later = Array.new
    pilots_for_testing_later << first_race_group.race_event_group_entries[0]
    post '/api/v1/lap_track',params: {transponder_token: pilots_for_testing_later.last.token, lap_time_in_ms: 10004}
    pilots_for_testing_later << first_race_group.race_event_group_entries[1]
    post '/api/v1/lap_track',params: {transponder_token: pilots_for_testing_later.last.token, lap_time_in_ms: 10003}
    pilots_for_testing_later << first_race_group.race_event_group_entries[2]
    post '/api/v1/lap_track',params: {transponder_token: pilots_for_testing_later.last.token, lap_time_in_ms: 10002}

    # close the first race
    RaceSession::stop_open_session
    first_race_group.reload
    expect(first_race_group.heat_done).to eq(true)
    expect(first_race_group.current).to eq(false)

    # start a second race

    adapter = RaceEventRaceSessionBuilderAdapter.new(race_event)
    expect(adapter.perform).to eq(true)

    race_session = RaceSession::get_open_session
    expect(race_session).to be_truthy

    expect(race_session.race_attendees.count).to eq(2) # max 2 pilots

    expect(race_event.current_group).to be_truthy

    second_race_group = race_event.current_group
    expect(second_race_group.group_no).to eq(2)

    pilots_for_testing_later << second_race_group.race_event_group_entries[0]
    post '/api/v1/lap_track',params: {transponder_token: pilots_for_testing_later.last.token, lap_time_in_ms: 10001}
    pilots_for_testing_later << second_race_group.race_event_group_entries[1]
    post '/api/v1/lap_track',params: {transponder_token: pilots_for_testing_later.last.token, lap_time_in_ms: 10000}

    # close the second race
    RaceSession::stop_open_session
    second_race_group.reload
    expect(second_race_group.heat_done).to eq(true)
    expect(second_race_group.current).to eq(false)

    # stop the heat and do the next one
    post '/api/v1/race_event/next_heat'
    expect(response.status).to eq 200

    race_event.reload
    expect(race_event.current_heat).to eq(2)
    first_group_of_second_heat = race_event.race_event_groups.where(heat_no: race_event.current_heat).where(group_no: 1).first
    expect(first_group_of_second_heat).to be_truthy
    expect(first_group_of_second_heat.race_event_group_entries.count).to eq(3)

    second_group_of_second_heat = race_event.race_event_groups.where(heat_no: race_event.current_heat).where(group_no: 2).first
    expect(second_group_of_second_heat).to be_truthy
    expect(second_group_of_second_heat.race_event_group_entries.count).to eq(2)
  end
end
