=begin
RaceSessionEventAdapter.new(RaceSessionAdapter.new(RaceSession.find(6)),12).perform
=end

class RaceSessionEventAdapter
  attr_accessor :transponder_token, :race_session_adapter

  def initialize(race_session_adapter,transponder_token)
    self.race_session_adapter = race_session_adapter
    self.transponder_token = transponder_token
  end

  def perform
    if self.race_session_adapter.race_mode == "competition"
      self.perform_for_competition_mode
    else
      self.perform_for_standard_mode
    end
  end

  def  perform_for_competition_mode
    max_laps_for_this_race = self.race_session_adapter.race_session.max_laps
    pilot_to_check = self.race_session_adapter.get_pilot_by_token(self.transponder_token)

    pilot_num_tracked_laps = self.race_session_adapter.race_session.lap_count_of_pilot(pilot_to_check)

    puts "pilot: #{pilot_to_check.name}"
    puts "pilot_num_tracked_laps: #{pilot_num_tracked_laps}"
    puts "max_laps_for_this_race: #{max_laps_for_this_race}"

    if(max_laps_for_this_race > pilot_num_tracked_laps)
      # play the lap announcement for the last tracked lap count for this pilot
      puts "RaceSessionEventAdapter::perform_for_competition_mode: triggering sound for lap #{pilot_num_tracked_laps}"
      RaceLapAnnouncerWorker.perform_async(pilot_num_tracked_laps)
    else
      #pilot finished race... let's see
      # RaceSessionEventAdapter.new(RaceSessionAdapter.new(RaceSession.find(6)),12).perform
      puts "finished race"

      data = PilotRaceLap.where(race_session_id: self.race_session_adapter.race_session.id).where(lap_num: max_laps_for_this_race)

      listing =  self.race_session_adapter.listing
      listing.each do |entry|
        if entry['pilot']['id'] == pilot_to_check.id
          RacePilotPlacementAnnouncerWorker.perform_async(entry['position']) # let's play the position
        end
      end
    end
  end

  def perform_for_standard_mode
    pilot_to_check = self.race_session_adapter.get_pilot_by_token(self.transponder_token)
    pilot_num_tracked_laps = self.race_session_adapter.race_session.lap_count_of_pilot(pilot_to_check)

    # play the lap announcement for the last tracked lap count for this pilot
    RaceLapAnnouncerWorker.perform_async(pilot_num_tracked_laps)
  end
end
