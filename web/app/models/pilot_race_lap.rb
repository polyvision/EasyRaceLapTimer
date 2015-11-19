class PilotRaceLap < ActiveRecord::Base
  belongs_to :race_session
  belongs_to :pilot
  
  after_create :filter_fastest_lap

  def formated_lap_time
    return ((self.lap_time / 1000.0) / 60.0).round(4)
  end
  
  def filter_fastest_lap
	t = RaceSession.find(self.race_session_id).pilot_race_laps.order("lap_time ASC").first
	if t.id == self.id
		Soundfile::play("sfx_fastet_lap")
	end
  end
end
