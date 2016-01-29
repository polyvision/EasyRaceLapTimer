=begin
adapter = RaceSessionAdapter.new(RaceSession.find(1))
RaceSessionEventAdapter.new(adapter,12).perform
=end

class RaceSessionEventAdapter
  attr_accessor :transponder_token, :race_session_adapter

  def initialize(race_session_adapter,transponder_token)
    self.race_session_adapter = race_session_adapter
    self.transponder_token = transponder_token
  end

  def perform
    max_laps_for_this_race = self.race_session_adapter.race_session.max_laps
    pilot_to_check = self.race_session_adapter.get_pilot_by_token(self.transponder_token)

    pilot_num_tracked_laps = self.race_session_adapter.race_session.lap_count_of_pilot(pilot_to_check)

    puts "pilot: #{pilot_to_check.name}"
    puts "pilot_num_tracked_laps: #{pilot_num_tracked_laps}"
    puts "max_laps_for_this_race: #{max_laps_for_this_race}"

    if(max_laps_for_this_race > pilot_num_tracked_laps)
      # play the lap announcement for the last tracked lap count for this pilot
      RaceLapAnnouncerWorker.perform_async(pilot_num_tracked_laps)
    end
  end
end
