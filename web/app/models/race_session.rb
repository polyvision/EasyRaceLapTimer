class RaceSession < ActiveRecord::Base
  has_many :pilot_race_laps

  def self.get_open_session
    return RaceSession.where(active: true).first
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
      c_pilot = Pilot.find(pilot_id)
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

    return listing_data
  end

  def num_pilots
    self.pilot_race_laps.group(:pilot_id).count.count
  end

  def total_laps
    self.pilot_race_laps.count
  end

  def fastest_lap_time
    self.pilot_race_laps.order("lap_time ASC").first.lap_time
  end

  def fastest_pilot
    self.pilot_race_laps.order("lap_time ASC").first.pilot
  end

  def average_lap_time
    self.pilot_race_laps.sum(:lap_time) / self.pilot_race_laps.count
  end

  def lap_count_of_pilot(pilot)
    return self.pilot_race_laps.where(pilot_id: pilot.id).count
  end

  def fastest_lap_of_pilot(pilot)
    return self.pilot_race_laps.where(pilot_id: pilot.id).order("lap_time ASC").first
  end

  def last_lap_of_pilot(pilot)
    return self.pilot_race_laps.where(pilot_id: pilot.id).order("id ASC").first
  end

  def avg_lap_time_of_pilot(pilot)
    self.pilot_race_laps.where(pilot_id: pilot.id).sum(:lap_time) / self.pilot_race_laps.where(pilot_id: pilot.id).count
  end
end
