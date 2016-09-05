class RacePilotPlacementAnnouncerWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(placement)

    sfx_file = Soundfile.where(name: "sfx_race_pilot_placement_#{placement}").first
    if sfx_file
      puts "RacePilotPlacementAnnouncerWorker::perform: #{placement} #{sfx_file.name}"
      Soundfile::play(sfx_file.name)
    end
  end
end
