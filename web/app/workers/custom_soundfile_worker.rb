class CustomSoundfileWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(sfx_id)
    CustomSoundfile::play(sfx_id)
  end
end
