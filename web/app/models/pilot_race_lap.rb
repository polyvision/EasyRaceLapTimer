class PilotRaceLap < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :race_session
  belongs_to :pilot

  after_create :filter_fastest_lap
  after_create :filter_mark_latest

  def formated_lap_time
    return ((self.lap_time / 1000.0) / 60.0).round(4)
  end

  def filter_fastest_lap
    t_fastest_lap = false
	  t = RaceSession.find(self.race_session_id).pilot_race_laps.order("lap_time ASC").first
  	if t.id == self.id
      t_fastest_lap = true
  		Soundfile::play("sfx_fastet_lap")
      return
  	end

    # it was not the fastest lap in the race, but it might be a personal best time?
    if t_fastest_lap == false
      t = RaceSession.find(self.race_session_id).pilot_race_laps.where(pilot_id: self.pilot_id).order("lap_time ASC").first
      if t.id == self.id
        Soundfile::play("sfx_personal_fastet_lap")
      end
    end
  end

  def filter_mark_latest
    RaceSession.find(self.race_session_id).pilot_race_laps.each do |l|
      l.update_attribute(:latest,false)
    end

    self.update_attribute(:latest,true)
  end

  def to_json
    t = Hash.new
    t[:id] = self.id
    t[:created_at] = self.created_at
    t[:created_at_timestamp] = self.created_at.to_i
    t[:lap_num] = self.lap_num
    t[:lap_time] = self.lap_time
    t[:pilot_id] = self.pilot_id
    t[:pilot] = Hash.new
    t[:pilot][:name] = self.pilot.name
    t[:pilot][:quad] = self.pilot.quad
    t[:pilot][:team] = self.pilot.team
    t[:race_session_id] = self.race_session_id
    t[:race_session] = Hash.new
    t[:race_session][:title] = self.race_session.title
    t[:race_session][:mode] = self.race_session.mode
    return t
  end
end
