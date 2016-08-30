class PilotRaceLap < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :race_session
  belongs_to :pilot

  after_create :filter_fastest_lap
  after_create :filter_mark_latest

  def formated_lap_time
    return ((self.lap_time / 1000.0) / 60.0).round(4)
  end

  def merged?
    if self.merged_with_id && self.merged_with_id > 0
      return true
    end

    return false
  end

  def unmerge
    to_recover = PilotRaceLap.only_deleted.where(id: self.merged_with_id).first
    to_recover.deleted_at = nil
    to_recover.save

    self.merged_with_id = 0
    self.lap_time = self.lap_time - to_recover.lap_time
    self.save
  end

  def merge_up
    for_merge = PilotRaceLap.where(pilot_id: self.pilot_id,race_session_id: self.race_session_id).where("id > ?", self.id).where(merged_with_id: 0).order("id ASC").first
    if for_merge
      for_merge.merge(self)
    end
  end

  def merge_down
    for_merge = PilotRaceLap.where(pilot_id: self.pilot_id,race_session_id: self.race_session_id).where("id < ?", self.id).where(merged_with_id: 0).order("id DESC").first
    if for_merge
      for_merge.merge(self)
    end
  end

  def merge(pilot_race_lap)
    self.merged_with_id = pilot_race_lap.id
    self.lap_time = self.lap_time + pilot_race_lap.lap_time
    self.save
    pilot_race_lap.destroy
  end

  def filter_fastest_lap
    t_fastest_lap = false
	  t = RaceSession.find(self.race_session_id).pilot_race_laps_valid.order("lap_time ASC").first
  	if t.id == self.id
      t_fastest_lap = true
      SoundFileWorker.perform_async("sfx_fastet_lap")
      return
  	end

    # it was not the fastest lap in the race, but it might be a personal best time?
    if t_fastest_lap == false
      t = RaceSession.find(self.race_session_id).pilot_race_laps_valid.where(pilot_id: self.pilot_id).order("lap_time ASC").first
      if t.id == self.id
        SoundFileWorker.perform_async("sfx_personal_fastet_lap")
      end
    end
  end

  def filter_mark_latest
    RaceSession.find(self.race_session_id).pilot_race_laps.each do |l|
      l.update_attribute(:latest,false)
    end

    self.update_attribute(:latest,true)
  end

  def mark_invalidated
    self.update_attribute(:invalidated,true)
  end

  def undo_invalidated
    self.update_attribute(:invalidated,false)
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
    t[:invalidated] = self.invalidated;
    return t
  end
end
