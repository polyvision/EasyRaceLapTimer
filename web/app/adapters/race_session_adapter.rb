class RaceSessionAdapter
  attr_accessor :race_session

  def initialize(race_session)
    self.race_session = race_session
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

  def listing
    if self.race_session.mode == "standard"
      return self.listing_standard_mode
    elsif self.race_session.mode == "competition"
      return self.listing_competition_mode
    end
  end

  def listing_standard_mode
    listing_data = Array.new

    self.race_session.pilot_race_laps.order("lap_time ASC").group(:pilot_id).pluck(:pilot_id).each_with_index do |pilot_id,index|
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

        listing_data << data
      end
    end

    return listing_data
  end

  def listing_competition_mode
    listing_data = Array.new

    self.race_session.pilot_race_laps.order("lap_num DESC,created_at ASC").group(:pilot_id).pluck(:pilot_id).each_with_index do |pilot_id,index|
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

        listing_data << data
      end
    end

    return listing_data
  end

  def track_lap_time(transponder_token,delta_time_in_ms)
    if self.race_session.mode == "standard"
      return self.track_lap_time_standard_mode(transponder_token,delta_time_in_ms)
    elsif self.race_session.mode == "competition"
      return self.track_lap_time_competition_mode(transponder_token,delta_time_in_ms)
    end
  end

  # tracking a lap in standard mode
  def track_lap_time_standard_mode(transponder_token,delta_time_in_ms)
    pilot = Pilot.where(transponder_token: transponder_token).first
    if !pilot
      raise Exception,  "no registered pilot with the transponder token #{transponder_token}"
    end

    # check if the lap tracking was too fast
    last_track = self.race_session.pilot_race_laps.where(pilot_id: pilot.id).order("ID DESC").first
    if last_track && last_track.created_at + ConfigValue::get_value("lap_timeout_in_seconds").value.to_i.seconds > Time.now
      raise Exception, 'request successfull but tracking was too fast concering the last track'
    end

    pilot_race_lap = self.race_session.add_lap(pilot,delta_time_in_ms)
    Soundfile::play("sfx_lap_beep")
    return pilot_race_lap
  end

  # tracking a lap in competition mode
  def track_lap_time_competition_mode(transponder_token,delta_time_in_ms)
    ra = self.race_session.race_attendees.where(transponder_token: transponder_token).first
    if !ra
      raise Exception,  "no registered pilot in competition mode with the transponder token #{transponder_token}"
    end

    # check if the lap tracking was too fast
    last_track = self.race_session.pilot_race_laps.where(pilot_id: ra.pilot.id).order("ID DESC").first
    if last_track && last_track.created_at + ConfigValue::get_value("lap_timeout_in_seconds").value.to_i.seconds > Time.now
      raise Exception, "request successfull but tracking was too fast concering the last track token: #{transponder_token} time: #{delta_time_in_ms} last track: #{last_track.to_json}"
    end

    if last_track && last_track.lap_num == self.race_session.max_laps
      raise Exception,  "pilot reached max lap in competition mode"
    end

    pilot_race_lap = self.race_session.add_lap(ra.pilot,delta_time_in_ms)
    Soundfile::play("sfx_lap_beep")
    return pilot_race_lap
  end
end
