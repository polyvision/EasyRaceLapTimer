class RaceAttendee < ActiveRecord::Base
  belongs_to :race_session
  belongs_to :pilot

  def as_json(x)
    t = Hash.new
    t[:id] = self.id
    t[:race_session_id] = self.race_session_id
    t[:pilot_id] = self.pilot_id
    t[:transponder_token] = self.transponder_token
    t[:pilot] = pilot
    return t
  end
end
