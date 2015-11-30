class RaceAttendee < ActiveRecord::Base
  belongs_to :race_session
  belongs_to :pilot
end
