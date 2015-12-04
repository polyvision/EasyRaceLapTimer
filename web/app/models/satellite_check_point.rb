class SatelliteCheckPoint < ActiveRecord::Base
  belongs_to :race_session
  belongs_to :race_attendee
end
