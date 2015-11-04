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

    self.pilot_race_laps.order("lap_time ASC").group(:pilot_id).pluck(:pilot_id).each do |pilot_id|
      c_pilot = Pilot.find(pilot_id)
      data = Hash.new
      data['pilot'] = c_pilot
      data['lap_count'] = self.lap_count_of_pilot(c_pilot)

      data['fastest_lap'] = Hash.new
      data['fastest_lap']['lap_num'] = self.fastest_lap_of_pilot(c_pilot).lap_num
      data['fastest_lap']['lap_time'] = self.fastest_lap_of_pilot(c_pilot).lap_time

      data['last_lap'] = Hash.new
      data['last_lap']['lap_num'] = self.fastest_lap_of_pilot(c_pilot).lap_num
      data['last_lap']['lap_time'] = self.fastest_lap_of_pilot(c_pilot).lap_time

      listing_data << data
    end

    return listing_data
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
end
