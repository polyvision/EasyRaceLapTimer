=begin
  FpvSportsRaceSessionBuilderAdapter.new(10).fetch
=end
class FpvSportsRaceSessionBuilderAdapter
  attr_accessor :error, :fetch_data, :fpv_sports_racing_event_id

  def initialize(fpv_sports_racing_event_id)
    self.fpv_sports_racing_event_id = fpv_sports_racing_event_id
  end

  def fetch
    json_data = FpvSportsApiAdapter::get_current_group(self.fpv_sports_racing_event_id)
    puts json_data
    data = Hash.new
    data['fpv_sports_group_id'] = json_data['group_id']
    data['fpv_sports_group_num'] = json_data['group_num']
    data['fpv_sports_heat_id'] = json_data['heat_id']
    data['fpv_sports_heat_num'] = json_data['heat_num']

    data['pilots'] = Array.new

    json_data['pilots'].each_with_index do |entry,index|
        t_pilot_data = Hash.new
        t_pilot_data['pilot'] = Pilot.where(fpvsports_race_event_pilot_id: entry['pilot_id']).first
        t_pilot_data['transponder_token'] = "VTX_#{index+1}"

        if t_pilot_data['pilot'] # only add the pilot if it exists
          data['pilots'] << t_pilot_data
        end
    end

    self.fetch_data = data
  end

  def build_race_session
    if self.fetch_data == nil
      return
    end

    if RaceSession::get_open_session
      self.error = "another race session is open"
      return false
    end

    race_session = RaceSession.create(hot_seat_enabled: false ,
                                    title: "Heat #{self.fetch_data['fpv_sports_heat_num']} Group: #{self.fetch_data['fpv_sports_group_num']}",
                                    active: true,
                                    mode: "competition",
                                    max_laps: 5,
                                    num_satellites: 0,
                                    time_penalty_per_satellite: 0,
                                    idle_time_in_seconds: 0,
                                    fpv_sports_racing_event_id: self.fpv_sports_racing_event_id,
                                    fpv_sports_race_event_heat_id: self.fetch_data['fpv_sports_heat_id'],
                                    fpv_sports_race_event_heat_num: self.fetch_data['fpv_sports_heat_num'],
                                    fpv_sports_race_event_heat_group_num: self.fetch_data['fpv_sports_group_num'],
                                    fpv_sports_race_event_heat_group_id: self.fetch_data['fpv_sports_group_id'] )

    race_session_adapter = RaceSessionAdapter.new(race_session)
    self.fetch_data['pilots'].each do |entry|
      race_session_adapter.add_pilot_to_competition_race(entry['pilot'],entry['transponder_token'])
    end
    race_session.update_attribute(:active,true)

  end
end
