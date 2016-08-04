require 'rails_helper'

RSpec.describe "RaceEventRaceSessionBuilderAdapter", type: :request do
  before(:each) do
    ConfigValue::set_value("time_between_lap_track_requests_in_seconds","4")
    ConfigValue::set_value("lap_max_lap_time_in_seconds","60")
    ConfigValue::set_value("lap_min_lap_time_in_seconds","4")
    ConfigValue::set_value("udp_broadcast_address","127.0.0.1")
  end

  it "test starting race sessions",:type => :request do
    RaceSession::stop_open_session
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

    adapter = RaceEventRaceSessionBuilderAdapter.new(race_event)
    expect(adapter.perform).to eq(true)

    race_session = RaceSession::get_open_session
    expect(race_session).to be_truthy

    expect(race_session.race_attendees.count).to eq(3) # max 3 pilots

    expect(race_event.current_group).to be_truthy

    first_race_group = race_event.current_group
    expect(first_race_group.group_no).to eq(1)

    # let's check if the pilots of the first group are also in the race session attendees
    pilot_ids = race_session.race_attendees.pluck(:pilot_id)
    first_race_group.race_event_group_entries.each do |entry|
      expect(pilot_ids.include?(entry.pilot.id)).to eq(true)
    end

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

    expect(race_session.race_attendees.count).to eq(3) # max 3 pilots

    expect(race_event.current_group).to be_truthy

    second_race_group = race_event.current_group
    expect(second_race_group.group_no).to eq(2)

    # let's check if the pilots of the first group are also in the race session attendees
    pilot_ids = race_session.race_attendees.pluck(:pilot_id)
    second_race_group.race_event_group_entries.each do |entry|
      expect(pilot_ids.include?(entry.pilot.id)).to eq(true)
    end

    # close the second race
    RaceSession::stop_open_session
    second_race_group.reload
    expect(second_race_group.heat_done).to eq(true)
    expect(second_race_group.current).to eq(false)

    # start a third race

    adapter = RaceEventRaceSessionBuilderAdapter.new(race_event)
    expect(adapter.perform).to eq(true)

    race_session = RaceSession::get_open_session
    expect(race_session).to be_truthy

    expect(race_session.race_attendees.count).to eq(1) # max 3 pilots

    expect(race_event.current_group).to be_truthy

    third_race_group = race_event.current_group
    expect(third_race_group.group_no).to eq(3)

    # let's check if the pilots of the first group are also in the race session attendees
    pilot_ids = race_session.race_attendees.pluck(:pilot_id)
    third_race_group.race_event_group_entries.each do |entry|
      expect(pilot_ids.include?(entry.pilot.id)).to eq(true)
    end

    # stop race 3
    RaceSession::stop_open_session

    # we are done with 3 races, heat 1 must be done now
    expect(race_event.get_next_group_in_heat_for_racing).to be_falsey

    # start a new heat
    expect(race_event.next_heat).to eq(true)
    race_event.reload
    expect(race_event.current_heat).to eq(2)
    expect(RaceEventGroupEntry.all.count).to eq(14)
    expect(RaceEventGroup.where(heat_done:true).count).to eq(3)
    expect(RaceEventGroup.where(heat_done:false).count).to eq(3)

    expect(race_event.get_next_group_in_heat_for_racing).to be_truthy # now there must be again a new group ready
  end
end
