=begin
  FpvSportsRaceResultAdapter::build_json(RaceSession.find(2)).to_json
=end

class FpvSportsRaceResultAdapter

  def self.build_hash(race_session)
    race_session_adapter = RaceSessionAdapter.new(race_session)
    listing_data = race_session_adapter.listing

    json_data = Hash.new
    json_data[:heat_id] = race_session.fpv_sports_race_event_heat_id
    json_data[:group_id] = race_session.fpv_sports_race_event_heat_group_id
    json_data[:pilots] = Array.new


    listing_data.each do |pilot_data|
      t_pilot = Hash.new
      t_pilot[:id] = pilot_data['pilot'].fpvsports_race_event_pilot_id
      t_pilot[:total_time] = pilot_data['race_time_sum_in_ms']
      t_pilot[:fastest_lap_time] = pilot_data['fastest_lap']['lap_time']
      t_pilot[:fastest_lap_num] = pilot_data['fastest_lap']['lap_num']
      t_pilot[:finish_position] = pilot_data['position']

      t_pilot['lap_times'] = Array.new
      race_session.pilot_race_laps.where(pilot_id: pilot_data['pilot']).order("id ASC").each do |lap|
        t_lap = Hash.new
        t_lap['lap_time_in_ms'] = lap.lap_time
        t_lap['lap_num'] = lap.lap_num
        t_pilot['lap_times'] << t_lap
      end

      json_data[:pilots] << t_pilot
    end

    return json_data
  end
end
