class RaceSession < ActiveRecord::Base
  acts_as_paranoid
  
  has_many :pilot_race_laps
  has_many :race_attendees
  enum mode:[:standard,:competition]

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
