class PilotRaceLap < ActiveRecord::Base
  belongs_to :race_session
  belongs_to :pilot

  def formated_lap_time
    return (self.lap_time / 1000.0).round(4)
  end
end
