# Soundfile::play("sfx_lap_beep")
class Soundfile < ActiveRecord::Base
  mount_uploader :file,SoundfileUploader

  def self.play(name)
	snd_file = Soundfile.where(name: name).first
  	if snd_file && snd_file.file && !snd_file.file.path.blank?
  		pid = spawn("aplay #{snd_file.file.path}")
  		Process.detach pid
  	end
  end
end
