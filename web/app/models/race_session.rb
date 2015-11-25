class RaceSession < ActiveRecord::Base
  has_many :pilot_race_laps

  def self.get_open_session
    return RaceSession.where(active: true).first
  end

  def self.stop_open_session
    t = RaceSession::get_open_session()
    if t && t.active
      t.update_attribute(:active, false)
    end
  end

  def add_lap(pilot,lap_time)

    pilot_race_lap = PilotRaceLap.new(pilot_id: pilot.id,race_session_id: self.id)
    pilot_race_lap.lap_time = lap_time
    pilot_race_lap.lap_num = PilotRaceLap.where(pilot_id: pilot.id,race_session_id: self.id).count + 1
    pilot_race_lap.save
    return pilot_race_lap
  end

  def listing
    listing_data = Array.new

    self.pilot_race_laps.order("lap_time ASC").group(:pilot_id).pluck(:pilot_id).each_with_index do |pilot_id,index|
      c_pilot = Pilot.where(id: pilot_id).first
      if c_pilot
        data = Hash.new
        data['position'] = index + 1
        data['pilot'] = c_pilot
        data['lap_count'] = self.lap_count_of_pilot(c_pilot)
        data['avg_lap_time'] = self.avg_lap_time_of_pilot(c_pilot)

        data['fastest_lap'] = Hash.new
        data['fastest_lap']['lap_num'] = self.fastest_lap_of_pilot(c_pilot).lap_num
        data['fastest_lap']['lap_time'] = self.fastest_lap_of_pilot(c_pilot).lap_time

        data['last_lap'] = Hash.new
        data['last_lap']['lap_num'] = self.last_lap_of_pilot(c_pilot).lap_num
        data['last_lap']['lap_time'] = self.last_lap_of_pilot(c_pilot).lap_time

        listing_data << data
      end
    end

    return listing_data
  end

  def num_pilots
    self.pilot_race_laps.group(:pilot_id).count.count
  end

  def total_laps
    self.pilot_race_laps.count
  end

  def fastest_lap_time
    t = self.pilot_race_laps.order("lap_time ASC").first
    return t.lap_time if t
    return 0
  end

   def fastest_pilot
    t = self.pilot_race_laps.order("lap_time ASC").first
    return t.pilot if t
    return nil
  end

  def average_lap_time
    begin
      self.pilot_race_laps.sum(:lap_time) / self.pilot_race_laps.count
    rescue Exception => ex
      return 0
    end
  end

  def lap_count_of_pilot(pilot)
    return self.pilot_race_laps.where(pilot_id: pilot.id).count
  end

  def fastest_lap_of_pilot(pilot)
    return self.pilot_race_laps.where(pilot_id: pilot.id).order("lap_time ASC").first
  end

  def last_lap_of_pilot(pilot)
    return self.pilot_race_laps.where(pilot_id: pilot.id).order("id DESC").first
  end

  def avg_lap_time_of_pilot(pilot)
    self.pilot_race_laps.where(pilot_id: pilot.id).sum(:lap_time) / self.pilot_race_laps.where(pilot_id: pilot.id).count
  end
end
