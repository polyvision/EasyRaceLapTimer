class Pilot < ActiveRecord::Base
  validates :transponder_token, uniqueness: true
  has_many :pilot_race_laps
  acts_as_paranoid
  mount_uploader :image, PilotImageUploader

  def total_races
    return 0
  end

  def total_laps
    self.pilot_race_laps.count
  end
end
