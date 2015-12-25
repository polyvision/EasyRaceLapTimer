class SoundFileWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(sfx_id)
    Soundfile::play(sfx_id)
  end
end
