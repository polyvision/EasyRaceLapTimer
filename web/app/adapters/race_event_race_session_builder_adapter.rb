# builds a race session on a group from a race event
class RaceEventRaceSessionBuilderAdapter
  attr_accessor :race_event, :error

  def initialize(race_event)
    self.race_event = race_event
  end

  def perform()
    if RaceSession::get_open_session
      self.error = "another race session is open"
      return false
    end

    racing_group = self.race_event.get_next_group_in_heat_for_racing
    if !racing_group
      self.error = "non available group for next heat"
      return false
    end
    race_session = RaceSession.create(hot_seat_enabled: false ,
                                    title: "Heat #{self.race_event.current_heat} Group: #{racing_group.group_no}",
                                    active: true,
                                    mode: "competition",
                                    max_laps: 5,
                                    num_satellites: 0,
                                    time_penalty_per_satellite: 0,
                                    idle_time_in_seconds: 0 )

    race_session_adapter = RaceSessionAdapter.new(race_session)
    racing_group.race_event_group_entries.each_with_index do |entry,index|
      race_session_adapter.add_pilot_to_competition_race(entry.pilot,"VTX_#{index+1}")
    end
    race_session.update_attribute(:active,true)

    racing_group.race_session_id = race_session.id
    racing_group.current = true
    racing_group.save

    return true
  end
end
