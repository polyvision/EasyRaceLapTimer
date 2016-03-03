# Soundfile::play("sfx_lap_beep")
class Soundfile < ActiveRecord::Base
  mount_uploader :file,SoundfileUploader

  def self.play(name)
	snd_file = Soundfile.where(name: name).first
  	if snd_file && snd_file.file && !snd_file.file.path.blank?
      puts "Soundfile:play(#{name})"
      if PlatformAdapter::platform? == :platform_osx
          system("afplay #{snd_file.file.path}")
      else
  		    system("aplay #{snd_file.file.path}")
      end
  	end
  end
end
