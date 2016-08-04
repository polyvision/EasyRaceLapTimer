class RaceSessionAdapter
  attr_accessor :race_session

  def initialize(race_session)
    self.race_session = race_session
  end

  def race_mode
    return self.race_session.mode
  end

  def add_pilot_to_competition_race(pilot,transponder_token)
    ra = self.race_session.race_attendees.build
    ra.pilot_id = pilot.id
    ra.transponder_token = transponder_token
    ra.save!

    puts "RaceSessionAdapter added pilot #{ra.pilot_id} token: #{ra.transponder_token} to race session: #{self.race_session.title}"
  end

  def add_pilots_to_competition_race(params_pilots)
    params_pilots.each do |t|
      t_pilot = Pilot.find(t['pilot_id'])
      ra = self.race_session.race_attendees.build
      ra.pilot_id = t_pilot.id
      ra.transponder_token = t['transponder_token']
      ra.save!
    end
  end

  def current_lap_for_pilot_by_token(token)
    pilot = self.get_pilot_by_token(token)
    t = self.race_session.pilot_race_laps_valid.where(pilot_id: pilot.id).order("lap_num DESC").first

    return t.lap_num+1 if t
    return 1
  end

  def get_pilot_by_token(token)
    pilot = nil
    if self.race_session.mode == "standard"
      return Pilot.where(transponder_token: token).first
    else
      return self.race_session.race_attendees.where(transponder_token: token).first.pilot
    end
    return false
  end

  def listing
    if self.race_session.mode == "standard"
      return self.listing_standard_mode
    elsif self.race_session.mode == "competition"
      return self.sort_list_by_time_penalties
    end
  end

  def current_lap_count
    t = self.race_session.pilot_race_laps_valid.order("lap_num DESC").first
    return t.lap_num if t
    return ""
  end

  def pilot_ids
    if self.race_session.mode == "standard"
      self.race_session.pilot_race_laps.group(:pilot_id).pluck(:pilot_id)
    else
      self.race_session.race_attendees.group(:pilot_id).pluck(:pilot_id)
    end
  end

  def listing_standard_mode
    listing_data = Array.new

    self.race_session.pilot_race_laps_valid.order("lap_time ASC").group(:pilot_id).pluck(:pilot_id).each_with_index do |pilot_id,index|
      c_pilot = Pilot.where(id: pilot_id).first
      if c_pilot
        data = Hash.new
        data['position'] = index + 1
        data['pilot'] = c_pilot
        data['lap_count'] = self.race_session.lap_count_of_pilot(c_pilot)
        data['avg_lap_time'] = self.race_session.avg_lap_time_of_pilot(c_pilot)

        data['fastest_lap'] = Hash.new
        data['fastest_lap']['lap_num'] = self.race_session.fastest_lap_of_pilot(c_pilot).lap_num
        data['fastest_lap']['lap_time'] = self.race_session.fastest_lap_of_pilot(c_pilot).lap_time

        data['last_lap'] = Hash.new
        data['last_lap']['lap_num'] = self.race_session.last_lap_of_pilot(c_pilot).lap_num
        data['last_lap']['lap_time'] = self.race_session.last_lap_of_pilot(c_pilot).lap_time
        data['latest_tracked'] = self.race_session.last_lap_of_pilot_is_lasted_tracked_time_of_race?(c_pilot)

        listing_data << data
      end
    end

    return listing_data
  end

  def listing_competition_mode

    listing_data = Array.new

    self.race_session.pilot_race_laps_valid.order("lap_num DESC,created_at ASC").group(:pilot_id).pluck(:pilot_id).each_with_index do |pilot_id,index|
      c_pilot = Pilot.where(id: pilot_id).first
      if c_pilot
        data = Hash.new
        data['position'] = index + 1
        data['pilot'] = c_pilot
        data['lap_count'] = self.race_session.lap_count_of_pilot(c_pilot)
        data['avg_lap_time'] = self.race_session.avg_lap_time_of_pilot(c_pilot)

        data['fastest_lap'] = Hash.new
        data['fastest_lap']['lap_num'] = self.race_session.fastest_lap_of_pilot(c_pilot).lap_num
        data['fastest_lap']['lap_time'] = self.race_session.fastest_lap_of_pilot(c_pilot).lap_time

        data['last_lap'] = Hash.new
        data['last_lap']['lap_num'] = self.race_session.last_lap_of_pilot(c_pilot).lap_num
        data['last_lap']['lap_time'] = self.race_session.last_lap_of_pilot(c_pilot).lap_time
        data['laps_left'] = self.race_session.max_laps.to_i - data['last_lap']['lap_num'].to_i
        data['latest_tracked'] = self.race_session.last_lap_of_pilot_is_lasted_tracked_time_of_race?(c_pilot)

        listing_data << data
      end
    end

    return listing_data
  end

  def sort_list_by_time_penalties()
    listing_data = Array.new

    pilot_time_sum_up = Hash.new
    self.race_session.pilot_race_laps_valid.order("created_at ASC").each do |lap|
      pilot = Pilot.find(lap.pilot_id)

      if !pilot_time_sum_up[lap.pilot_id]
        pilot_time_sum_up[lap.pilot_id] = Hash.new
        pilot_time_sum_up[lap.pilot_id]['race_time_sum_in_ms'] = 0
        pilot_time_sum_up[lap.pilot_id]['race_time_sum_in_ms_without_penalty'] = 0
        pilot_time_sum_up[lap.pilot_id]['num_time_penalties'] = 0
        pilot_time_sum_up[lap.pilot_id]['sum_time_penalties_in_ms'] = 0
      end

      pilot_time_sum_up[lap.pilot_id]['race_time_sum_in_ms'] += lap.lap_time
      pilot_time_sum_up[lap.pilot_id]['race_time_sum_in_ms_without_penalty'] += lap.lap_time

      if self.time_penalty_for_lap?(pilot,lap.lap_num)
        pilot_time_sum_up[lap.pilot_id]['num_time_penalties'] += self.num_time_penalties_for_lap(pilot,lap.lap_num)
        pilot_time_sum_up[lap.pilot_id]['race_time_sum_in_ms'] += self.num_time_penalties_for_lap(pilot,lap.lap_num) * self.race_session.time_penalty_per_satellite
        pilot_time_sum_up[lap.pilot_id]['sum_time_penalties_in_ms'] += self.num_time_penalties_for_lap(pilot,lap.lap_num) * self.race_session.time_penalty_per_satellite
      end
    end

    # let's alter the listing according to the racing times with penalties etc
    listing_data = self.listing_competition_mode
    listing_data.each_with_index do |entry,index|
      listing_data[index]['race_time_sum_in_ms'] = pilot_time_sum_up[entry['pilot']['id']]['race_time_sum_in_ms']
      listing_data[index]['race_time_sum_in_ms_without_penalty'] = pilot_time_sum_up[entry['pilot']['id']]['race_time_sum_in_ms_without_penalty']
      listing_data[index]['num_time_penalties'] = pilot_time_sum_up[entry['pilot']['id']]['num_time_penalties']
      listing_data[index]['sum_time_penalties_in_ms'] = pilot_time_sum_up[entry['pilot']['id']]['sum_time_penalties_in_ms']
    end

    #listing_data = listing_data.sort!{|a,b| a['race_time_sum_in_ms'] <=> b['race_time_sum_in_ms']}
    listing_data = listing_data.sort_by{|a| [a['laps_left'], a['race_time_sum_in_ms']]}
    return listing_data
  end

  def track_lap_time(transponder_token,delta_time_in_ms)
    if self.race_session.mode == "standard"
      res = self.track_lap_time_standard_mode(transponder_token,delta_time_in_ms)
      RaceSessionEventAdapter.new(self,transponder_token).perform
    elsif self.race_session.mode == "competition"
      res =  self.track_lap_time_competition_mode(transponder_token,delta_time_in_ms)
      RaceSessionEventAdapter.new(self,transponder_token).perform
      return res
    end
  end

  def track_satellite_check_point(token)
    ra = self.race_session.race_attendees.where(transponder_token: token).first
    if ra
      return SatelliteCheckPoint.create(race_session_id: self.race_session.id,race_attendee_id: ra.id,num_lap: self.current_lap_for_pilot_by_token(token))
    else
      return false
    end
  end

  def num_satellite_check_points_for_lap(pilot,lap_num)
    return SatelliteCheckPoint.joins(:race_attendee).where(race_session_id: self.race_session.id, num_lap: lap_num).where("race_attendees.pilot_id = ?",pilot.id).count
  end

  def time_penalty_for_lap?(pilot,lap_num)
    if self.num_satellite_check_points_for_lap(pilot,lap_num) < self.race_session.num_satellites.to_i
      return true
    end
    return false
  end

  def num_time_penalties_for_lap(pilot,lap_num)
    if self.num_satellite_check_points_for_lap(pilot,lap_num) < self.race_session.num_satellites
      return self.race_session.num_satellites - self.num_satellite_check_points_for_lap(pilot,lap_num)
    end
    return 0
  end

  # tracking a lap in standard mode
  def track_lap_time_standard_mode(transponder_token,delta_time_in_ms)
    pilot = Pilot.where(transponder_token: transponder_token).first
    if !pilot
      raise Exception,  "no registered pilot with the transponder token #{transponder_token}"
    end

    # check if the lap tracking was too fast
    last_track = self.race_session.pilot_race_laps.where(pilot_id: pilot.id).order("ID DESC").first
    if last_track && last_track.created_at + ConfigValue::get_value("time_between_lap_track_requests_in_seconds").value.to_i.seconds > Time.now
      raise Exception, 'request successfull but tracking was too fast concering the last track'
    end

    pilot_race_lap = self.race_session.add_lap(pilot,delta_time_in_ms)
    SoundFileWorker.perform_async("sfx_lap_beep")
    return pilot_race_lap
  end

  # tracking a lap in competition mode
  def track_lap_time_competition_mode(transponder_token,delta_time_in_ms)
    ra = self.race_session.race_attendees.where(transponder_token: transponder_token).first
    if !ra && self.race_session.hot_seat_enabled == false
      raise Exception,  "no registered pilot in competition mode with the transponder token #{transponder_token}"
    elsif !ra && self.race_session.hot_seat_enabled == true
      pilot = Pilot.where(transponder_token: transponder_token).first
      if !pilot
        raise Exception,  "no registered pilot in competition mode with the transponder token #{transponder_token}"
      else
        self.add_pilots_to_competition_race([{'pilot_id' => pilot.id, 'transponder_token' => pilot.transponder_token}])
        ra = self.race_session.race_attendees.where(transponder_token: transponder_token).first
      end
    end



    # check if the lap tracking was too fast
    last_track = self.race_session.pilot_race_laps.where(pilot_id: ra.pilot.id).order("ID DESC").first
    if last_track && last_track.created_at + ConfigValue::get_value("time_between_lap_track_requests_in_seconds").value.to_i.seconds > Time.now
      raise Exception, "request successfull but tracking was too fast concering the last track token: #{transponder_token} time: #{delta_time_in_ms} last track: #{last_track.to_json}"
    end

    if last_track && last_track.lap_num == self.race_session.max_laps
      raise Exception,  "pilot reached max lap in competition mode"
    end

    pilot_race_lap = self.race_session.add_lap(ra.pilot,delta_time_in_ms)
    SoundFileWorker.perform_async("sfx_lap_beep")
    return pilot_race_lap
  end

  def monitor_data
    json_data = Hash.new
    json_data['session'] = Hash.new#
    json_data['session']['title'] = self.race_session.title
    json_data['session']['maps_laps'] = self.race_session.max_laps
    json_data['session']['current_lap_count'] = self.current_lap_count
    json_data['data'] = self.listing
    return json_data
  end
end
