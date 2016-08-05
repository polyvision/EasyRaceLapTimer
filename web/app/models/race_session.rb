class RaceSession < ActiveRecord::Base
  acts_as_paranoid

  has_many :pilot_race_laps
  has_many :race_attendees
  enum mode:[:standard,:competition]
  after_create :filter_reset_ir_daemon

  def self.get_open_session
    return  RaceSession.where(active: true).first
  end

  def self.get_session_from_previous
    last_session =  RaceSession.where(active: true).first
    # ok, nothing found, lets see if idle_time_in_seconds was greater than zero in the last race
    # if yes it means we shall auto restart a new race
    if !last_session
      last_session = RaceSession.order("created_at DESC").first
      if last_session && last_session.idle_time_in_seconds > 0
        return RaceSession::clone_race_session(last_session)
      end
    end

    return nil
  end

  def self.clone_race_session(src_session)
    new_session = RaceSession.new
    new_session.title = src_session.title
    new_session.active = true
    new_session.mode = src_session.mode
    new_session.max_laps = src_session.max_laps
    new_session.num_satellites = src_session.num_satellites
    new_session.time_penalty_per_satellite = src_session.time_penalty_per_satellite
    new_session.hot_seat_enabled = src_session.hot_seat_enabled
    new_session.idle_time_in_seconds = src_session.idle_time_in_seconds

    new_session.save!
    new_session.update_attribute(:title,new_session.title) # a better naming ...

    if new_session.mode == "competition" # we need to clone the pilots also
      src_session.race_attendees.each do |p|
        new_attendee = p.class.new(p.attributes)
        new_attendee.id = nil
        new_attendee.race_session_id = new_session.id
        new_attendee.save!
      end
    end
    return new_session
  end

  def self.stop_open_session
    t = RaceSession::get_open_session()
    if t && t.active
      t.update_attribute(:active, false)

      # if there's a race event group, we have to mark it as done
      race_event_group = RaceEventGroup.where(race_session_id: t.id).first
      if race_event_group
        race_event_group.heat_done = true
        race_event_group.current = false
        race_event_group.save
        race_event_group.calculate_race_data
        puts "RaceSession::stop_open_session closed marked group: #{race_event_group.id} as done"
      end
    end
  end

  def filter_reset_ir_daemon
    load "#{Rails.root}/lib/ir_daemon_cmd.rb"
    ::IRDaemonCmd::send("RESET#\n")
  end

  def add_lap(pilot,lap_time)

    pilot_race_lap = PilotRaceLap.new(pilot_id: pilot.id,race_session_id: self.id)
    pilot_race_lap.lap_time = lap_time
    pilot_race_lap.lap_num = PilotRaceLap.where(pilot_id: pilot.id,race_session_id: self.id).count + 1
    pilot_race_lap.save
    return pilot_race_lap
  end

  def num_pilots
    self.pilot_race_laps.group(:pilot_id).count.count
  end

  def total_laps
    self.pilot_race_laps_valid.count
  end

  def fastest_lap_time
    t = self.pilot_race_laps_valid.order("lap_time ASC").first
    return t.lap_time if t
    return 0
  end

   def fastest_pilot
    t = self.pilot_race_laps_valid.order("lap_time ASC").first
    return t.pilot if t
    return nil
  end

  def average_lap_time
    begin
      self.pilot_race_laps_valid.sum(:lap_time) / self.pilot_race_laps.count
    rescue Exception => ex
      return 0
    end
  end

  # returns the last tracked lap time creation date, used for idle time of a race
  def last_created_at_of_tracked_lap
    if self.pilot_race_laps.last
      return self.pilot_race_laps.last.created_at
    else
      return self.created_at
    end
  end

  def lap_count_of_pilot(pilot)
    return self.pilot_race_laps_valid.where(pilot_id: pilot.id).count
  end

  def fastest_lap_of_pilot(pilot)
    return self.pilot_race_laps_valid.where(pilot_id: pilot.id).order("lap_time ASC").first
  end

  def last_lap_of_pilot(pilot)
    return self.pilot_race_laps.where(pilot_id: pilot.id).order("id DESC").first
  end

  def last_lap_of_pilot_is_lasted_tracked_time_of_race?(pilot)
    t=  self.pilot_race_laps_valid.where(pilot_id: pilot.id).order("id DESC").first
    return t.latest if t
    return false
  end

  def pilot_race_laps_valid
    return self.pilot_race_laps.where(invalidated: false)
  end

  def avg_lap_time_of_pilot(pilot)
    self.pilot_race_laps_valid.where(pilot_id: pilot.id).sum(:lap_time) / self.pilot_race_laps.where(pilot_id: pilot.id).count
  end
end
