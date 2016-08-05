=begin
  load "#{Rails.root}/lib/race_simulator.rb"
  RaceSimulator::perform
=end
class RaceSimulator
  def self.perform
    race_session = RaceSession::get_open_session

    if !race_session
      return false
    end

    pilots = race_session.race_attendees

    for i in 0..5 do
      pilots.each do |pilot|
        RestClient.post "http://localhost:3000/api/v1/lap_track", {transponder_token: pilot.transponder_token, lap_time_in_ms: 10000 + pilot.id + i}
        puts "tracked lap #{i} for #{pilot.id}"
      end
      sleep(15)
    end
  end
end
