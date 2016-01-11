class CustomSoundfile < ActiveRecord::Base
  mount_uploader :file,CustomSoundfileUploader

  def self.play(id)
	snd_file = CustomSoundfile.where(id: id).first
  	if snd_file && snd_file.file && !snd_file.file.path.blank?
  		pid = spawn("aplay #{snd_file.file.path}")
  		Process.detach pid
  	end
  end
end
